import cron from 'node-cron';
import mongoose from 'mongoose';
import { Company } from '../models/Company.js';
import { TestSession } from '../models/TestSession.js';
import { UserKnowledgeProfile } from '../models/UserKnowledgeProfile.js';
import { HrReport } from '../models/HrReport.js';
import { User } from '../models/User.js';
import { effectiveMemoryStrengthExpr } from '../services/sm2.js';

const RISK = {
  highScore: 40,
  mediumScore: 70,
  highDecay: 0.7,
  mediumDecay: 0.4,
  minSampleSize: 5,
};

function classifyRisk(session, knowledge) {
  const hasSessionSample = (session.totalSessions ?? 0) > 0;
  const hasKnowledgeSample = (knowledge.sampleSize ?? 0) >= RISK.minSampleSize;
  if (!hasSessionSample && !hasKnowledgeSample) return 'unknown';

  const score = hasSessionSample ? session.avgScore : null;
  const decay = hasKnowledgeSample ? knowledge.decayRate : null;
  const highByScore = score !== null && score < RISK.highScore;
  const highByDecay = decay !== null && decay > RISK.highDecay;
  const medByScore = score !== null && score < RISK.mediumScore;
  const medByDecay = decay !== null && decay > RISK.mediumDecay;

  if (highByScore || highByDecay) return 'high';
  if (medByScore || medByDecay) return 'medium';
  return 'low';
}

async function generateWeeklyReportForCompany(company) {
  const now = new Date();
  const periodEnd = new Date(now);
  periodEnd.setHours(23, 59, 59, 999);

  const periodStart = new Date(now);
  periodStart.setDate(periodStart.getDate() - 7);
  periodStart.setHours(0, 0, 0, 0);

  const companyId = new mongoose.Types.ObjectId(company._id);

  const [sessionStats, knowledgeStats, departmentBreakdown] = await Promise.all([
    TestSession.aggregate([
      {
        $match: {
          companyId,
          isCompleted: true,
          completedAt: { $gte: periodStart, $lte: periodEnd },
        },
      },
      {
        $group: {
          _id: null,
          totalSessions: { $sum: 1 },
          avgScore: { $avg: '$scorePercent' },
          uniqueEmployees: { $addToSet: '$userId' },
        },
      },
      {
        $project: {
          _id: 0,
          totalSessions: 1,
          avgScore: { $round: ['$avgScore', 2] },
          activeEmployeeCount: { $size: '$uniqueEmployees' },
        },
      },
    ]),
    UserKnowledgeProfile.aggregate([
      { $match: { companyId } },
      { $addFields: { effectiveStrength: effectiveMemoryStrengthExpr } },
      {
        $group: {
          _id: null,
          sampleSize: { $sum: 1 },
          avgEffectiveStrength: { $avg: '$effectiveStrength' },
        },
      },
      {
        $project: {
          _id: 0,
          sampleSize: 1,
          avgEffectiveStrength: { $round: ['$avgEffectiveStrength', 4] },
          decayRate: { $round: [{ $subtract: [1, '$avgEffectiveStrength'] }, 4] },
        },
      },
    ]),
    TestSession.aggregate([
      {
        $match: {
          companyId,
          isCompleted: true,
          completedAt: { $gte: periodStart, $lte: periodEnd },
        },
      },
      {
        $lookup: { from: 'users', localField: 'userId', foreignField: '_id', as: 'user' },
      },
      { $unwind: '$user' },
      {
        $group: {
          _id: '$user.departmentId',
          avgScore: { $avg: '$scorePercent' },
          sessionCount: { $sum: 1 },
        },
      },
      {
        $lookup: { from: 'departments', localField: '_id', foreignField: '_id', as: 'department' },
      },
      { $unwind: { path: '$department', preserveNullAndEmptyArrays: true } },
      {
        $project: {
          departmentName: { $ifNull: ['$department.name', 'No Department'] },
          avgScore: { $round: ['$avgScore', 1] },
          sessionCount: 1,
        },
      },
      { $sort: { avgScore: 1 } },
    ]),
  ]);

  const session = sessionStats[0] ?? { totalSessions: 0, avgScore: 0, activeEmployeeCount: 0 };
  const knowledge = knowledgeStats[0] ?? { sampleSize: 0, avgEffectiveStrength: 0, decayRate: 0 };

  if (session.totalSessions === 0) return;

  const riskLevel = classifyRisk(session, knowledge);

  const adminUser = await User.findOne({ companyId, role: 'admin' }).select('_id').lean();
  if (!adminUser) return;

  await HrReport.create({
    companyId: company._id,
    generatedBy: adminUser._id,
    reportType: 'weekly_summary',
    periodStart,
    periodEnd,
    avgScore: session.avgScore ?? 0,
    decayRate: knowledge.decayRate ?? 0,
    riskLevel,
    reportData: { sessionStats: session, knowledgeStats: knowledge, departmentBreakdown },
  });
}

export function startWeeklyReportJob() {
  cron.schedule('0 1 * * 1', async () => {
    const companies = await Company.find({ isActive: true }).select('_id').lean();
    await Promise.allSettled(companies.map(generateWeeklyReportForCompany));
  });
}
