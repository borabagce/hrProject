import cron from 'node-cron';
import mongoose from 'mongoose';
import { Company } from '../models/Company.js';
import { TestSession } from '../models/TestSession.js';
import { UserKnowledgeProfile } from '../models/UserKnowledgeProfile.js';
import { HrReport } from '../models/HrReport.js';
import { User } from '../models/User.js';

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
      {
        $group: {
          _id: null,
          avgMemoryStrength: { $avg: '$memoryStrength' },
        },
      },
      {
        $project: {
          _id: 0,
          avgMemoryStrength: { $round: ['$avgMemoryStrength', 4] },
          decayRate: { $round: [{ $subtract: [1, '$avgMemoryStrength'] }, 4] },
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
  const knowledge = knowledgeStats[0] ?? { avgMemoryStrength: 0, decayRate: 1 };

  if (session.totalSessions === 0) return;

  const avgScore = session.avgScore ?? 0;
  const decayRate = knowledge.decayRate ?? 1;

  let riskLevel;
  if (avgScore < 40 || decayRate > 0.7) riskLevel = 'high';
  else if (avgScore < 70 || decayRate > 0.4) riskLevel = 'medium';
  else riskLevel = 'low';

  const adminUser = await User.findOne({ companyId, role: 'admin' }).select('_id').lean();
  if (!adminUser) return;

  await HrReport.create({
    companyId: company._id,
    generatedBy: adminUser._id,
    reportType: 'weekly_summary',
    periodStart,
    periodEnd,
    avgScore,
    decayRate,
    riskLevel,
    reportData: { sessionStats: session, knowledgeStats: knowledge, departmentBreakdown },
  });
}

export function startWeeklyReportJob() {
  // Every Monday at 01:00
  cron.schedule('0 1 * * 1', async () => {
    const companies = await Company.find({ isActive: true }).select('_id').lean();
    await Promise.allSettled(companies.map(generateWeeklyReportForCompany));
  });
}
