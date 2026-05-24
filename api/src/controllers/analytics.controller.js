import mongoose from 'mongoose';
import { UserAnswer } from '../models/UserAnswer.js';
import { TestSession } from '../models/TestSession.js';
import { User } from '../models/User.js';
import { UserKnowledgeProfile } from '../models/UserKnowledgeProfile.js';
import { HrReport } from '../models/HrReport.js';
import { ApiError } from '../utils/ApiError.js';
import { effectiveMemoryStrengthExpr } from '../services/sm2.js';

const RISK_THRESHOLDS = {
  highScore: 40,
  mediumScore: 70,
  highDecay: 0.7,
  mediumDecay: 0.4,
  minSampleSize: 5,
};

export const getCompanyOverview = async (req, res, next) => {
  try {
    const companyId = new mongoose.Types.ObjectId(req.user.companyId);

    const [sessionStats, topWrongQuestions, knowledgeOverview, weakestCategories] = await Promise.all([
      TestSession.aggregate([
        { $match: { companyId, isCompleted: true } },
        {
          $group: {
            _id: null,
            totalSessions: { $sum: 1 },
            avgScore: { $avg: '$scorePercent' },
            minScore: { $min: '$scorePercent' },
            maxScore: { $max: '$scorePercent' },
          },
        },
        {
          $project: {
            _id: 0,
            totalSessions: 1,
            avgScore: { $round: ['$avgScore', 1] },
            minScore: 1,
            maxScore: 1,
          },
        },
      ]),
      UserAnswer.aggregate([
        { $match: { companyId, isCorrect: false } },
        { $group: { _id: '$questionId', wrongCount: { $sum: 1 } } },
        { $sort: { wrongCount: -1 } },
        { $limit: 10 },
        {
          $lookup: {
            from: 'questions',
            localField: '_id',
            foreignField: '_id',
            as: 'question',
          },
        },
        { $unwind: '$question' },
        {
          $project: {
            wrongCount: 1,
            questionText: '$question.text',
            difficulty: '$question.difficulty',
            categoryId: '$question.categoryId',
          },
        },
      ]),
      UserKnowledgeProfile.aggregate([
        { $match: { companyId } },
        {
          $addFields: {
            effectiveStrength: effectiveMemoryStrengthExpr,
          },
        },
        {
          $group: {
            _id: null,
            totalTracked: { $sum: 1 },
            dueCount: { $sum: { $cond: [{ $lte: ['$nextReviewDate', '$$NOW'] }, 1, 0] } },
            avgEffectiveStrength: { $avg: '$effectiveStrength' },
            avgEasinessFactor: { $avg: '$easinessFactor' },
            activeLearners: { $addToSet: '$userId' },
          },
        },
        {
          $project: {
            _id: 0,
            totalTracked: 1,
            dueCount: 1,
            activeLearnerCount: { $size: '$activeLearners' },
            avgEffectiveStrength: { $round: ['$avgEffectiveStrength', 4] },
            avgEasinessFactor: { $round: ['$avgEasinessFactor', 2] },
          },
        },
      ]),
      UserKnowledgeProfile.aggregate([
        { $match: { companyId } },
        {
          $addFields: { effectiveStrength: effectiveMemoryStrengthExpr },
        },
        {
          $lookup: {
            from: 'questions',
            localField: 'questionId',
            foreignField: '_id',
            as: 'question',
          },
        },
        { $unwind: '$question' },
        {
          $group: {
            _id: '$question.categoryId',
            avgStrength: { $avg: '$effectiveStrength' },
            sampleSize: { $sum: 1 },
          },
        },
        { $match: { sampleSize: { $gte: RISK_THRESHOLDS.minSampleSize } } },
        {
          $lookup: {
            from: 'categories',
            localField: '_id',
            foreignField: '_id',
            as: 'category',
          },
        },
        { $unwind: '$category' },
        {
          $project: {
            categoryName: '$category.name',
            avgStrength: { $round: ['$avgStrength', 4] },
            sampleSize: 1,
          },
        },
        { $sort: { avgStrength: 1 } },
        { $limit: 5 },
      ]),
    ]);

    res.json({
      success: true,
      data: {
        sessionStats: sessionStats[0] ?? {
          totalSessions: 0,
          avgScore: 0,
          minScore: 0,
          maxScore: 0,
        },
        topWrongQuestions,
        knowledgeOverview: knowledgeOverview[0] ?? {
          totalTracked: 0,
          dueCount: 0,
          activeLearnerCount: 0,
          avgEffectiveStrength: 0,
          avgEasinessFactor: 2.5,
        },
        weakestCategories,
      },
    });
  } catch (err) {
    next(err);
  }
};

export const getEmployeeAnalytics = async (req, res, next) => {
  try {
    const userId = new mongoose.Types.ObjectId(req.params.userId);
    const companyId = new mongoose.Types.ObjectId(req.user.companyId);

    const targetUser = await User.findOne({ _id: userId, companyId });
    if (!targetUser) throw ApiError.notFound('User not found');

    const [sessionHistory, wrongByCategory, weeklyTrend, knowledgeStats] = await Promise.all([
      TestSession.find({ userId, companyId, isCompleted: true })
        .sort({ completedAt: -1 })
        .limit(20)
        .select('weekNumber year scorePercent correctCount totalQuestions completedAt sessionType'),

      UserAnswer.aggregate([
        { $match: { userId, companyId } },
        {
          $lookup: {
            from: 'questions',
            localField: 'questionId',
            foreignField: '_id',
            as: 'question',
          },
        },
        { $unwind: '$question' },
        {
          $group: {
            _id: '$question.categoryId',
            total: { $sum: 1 },
            wrong: { $sum: { $cond: [{ $eq: ['$isCorrect', false] }, 1, 0] } },
          },
        },
        {
          $lookup: {
            from: 'categories',
            localField: '_id',
            foreignField: '_id',
            as: 'category',
          },
        },
        { $unwind: '$category' },
        {
          $project: {
            categoryName: '$category.name',
            total: 1,
            wrong: 1,
            errorRate: {
              $round: [{ $multiply: [{ $divide: ['$wrong', '$total'] }, 100] }, 1],
            },
          },
        },
        { $sort: { errorRate: -1 } },
      ]),

      TestSession.aggregate([
        { $match: { userId, companyId, isCompleted: true } },
        { $sort: { year: -1, weekNumber: -1 } },
        { $limit: 12 },
        { $sort: { year: 1, weekNumber: 1 } },
        {
          $project: {
            label: {
              $concat: ['W', { $toString: '$weekNumber' }, '/', { $toString: '$year' }],
            },
            score: '$scorePercent',
          },
        },
      ]),

      UserKnowledgeProfile.aggregate([
        { $match: { userId, companyId } },
        { $addFields: { effectiveStrength: effectiveMemoryStrengthExpr } },
        {
          $group: {
            _id: null,
            totalTracked: { $sum: 1 },
            dueCount: { $sum: { $cond: [{ $lte: ['$nextReviewDate', '$$NOW'] }, 1, 0] } },
            avgEffectiveStrength: { $avg: '$effectiveStrength' },
            avgEasinessFactor: { $avg: '$easinessFactor' },
          },
        },
        {
          $project: {
            _id: 0,
            totalTracked: 1,
            dueCount: 1,
            avgEffectiveStrength: { $round: ['$avgEffectiveStrength', 4] },
            avgEasinessFactor: { $round: ['$avgEasinessFactor', 2] },
          },
        },
      ]),
    ]);

    res.json({
      success: true,
      data: {
        user: { _id: targetUser._id, fullName: targetUser.fullName, email: targetUser.email },
        sessionHistory,
        wrongByCategory,
        weeklyTrend,
        knowledgeStats: knowledgeStats[0] ?? {
          totalTracked: 0,
          dueCount: 0,
          avgEffectiveStrength: 0,
          avgEasinessFactor: 2.5,
        },
      },
    });
  } catch (err) {
    next(err);
  }
};

export const getQuestionAnalytics = async (req, res, next) => {
  try {
    const companyId = new mongoose.Types.ObjectId(req.user.companyId);

    const stats = await UserAnswer.aggregate([
      { $match: { companyId } },
      {
        $group: {
          _id: '$questionId',
          totalAttempts: { $sum: 1 },
          wrongCount: { $sum: { $cond: [{ $eq: ['$isCorrect', false] }, 1, 0] } },
          avgResponseTime: { $avg: '$responseTimeSec' },
        },
      },
      {
        $addFields: {
          errorRate: { $multiply: [{ $divide: ['$wrongCount', '$totalAttempts'] }, 100] },
        },
      },
      { $sort: { errorRate: -1 } },
      {
        $lookup: {
          from: 'questions',
          localField: '_id',
          foreignField: '_id',
          as: 'question',
        },
      },
      { $unwind: '$question' },
      {
        $project: {
          totalAttempts: 1,
          wrongCount: 1,
          errorRate: { $round: ['$errorRate', 1] },
          avgResponseTime: { $round: ['$avgResponseTime', 1] },
          questionText: '$question.text',
          difficulty: '$question.difficulty',
          type: '$question.type',
          categoryId: '$question.categoryId',
        },
      },
    ]);

    res.json({ success: true, data: stats });
  } catch (err) {
    next(err);
  }
};

export const getDepartmentAnalytics = async (req, res, next) => {
  try {
    const companyId = new mongoose.Types.ObjectId(req.user.companyId);

    const stats = await TestSession.aggregate([
      { $match: { companyId, isCompleted: true } },
      {
        $lookup: {
          from: 'users',
          localField: 'userId',
          foreignField: '_id',
          as: 'user',
        },
      },
      { $unwind: '$user' },
      {
        $group: {
          _id: '$user.departmentId',
          avgScore: { $avg: '$scorePercent' },
          totalSessions: { $sum: 1 },
          employeeCount: { $addToSet: '$userId' },
        },
      },
      {
        $addFields: { employeeCount: { $size: '$employeeCount' } },
      },
      {
        $lookup: {
          from: 'departments',
          localField: '_id',
          foreignField: '_id',
          as: 'department',
        },
      },
      { $unwind: { path: '$department', preserveNullAndEmptyArrays: true } },
      {
        $project: {
          departmentName: { $ifNull: ['$department.name', 'No Department'] },
          avgScore: { $round: ['$avgScore', 1] },
          totalSessions: 1,
          employeeCount: 1,
        },
      },
      { $sort: { avgScore: -1 } },
    ]);

    res.json({ success: true, data: stats });
  } catch (err) {
    next(err);
  }
};

export const getMyAnalytics = async (req, res, next) => {
  req.params.userId = req.user._id.toString();
  return getEmployeeAnalytics(req, res, next);
};

export const generateReport = async (req, res, next) => {
  try {
    const companyId = new mongoose.Types.ObjectId(req.user.companyId);
    const { reportType, periodStart, periodEnd } = req.body;

    const start = new Date(periodStart);
    const end = new Date(periodEnd);

    const [sessionStats, knowledgeStats, departmentBreakdown] = await Promise.all([
      TestSession.aggregate([
        {
          $match: {
            companyId,
            isCompleted: true,
            completedAt: { $gte: start, $lte: end },
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
            avgEasinessFactor: { $avg: '$easinessFactor' },
          },
        },
        {
          $project: {
            _id: 0,
            sampleSize: 1,
            avgEffectiveStrength: { $round: ['$avgEffectiveStrength', 4] },
            decayRate: {
              $round: [{ $subtract: [1, '$avgEffectiveStrength'] }, 4],
            },
          },
        },
      ]),
      TestSession.aggregate([
        {
          $match: {
            companyId,
            isCompleted: true,
            completedAt: { $gte: start, $lte: end },
          },
        },
        {
          $lookup: {
            from: 'users',
            localField: 'userId',
            foreignField: '_id',
            as: 'user',
          },
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
          $lookup: {
            from: 'departments',
            localField: '_id',
            foreignField: '_id',
            as: 'department',
          },
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

    const hasKnowledgeSample = (knowledge.sampleSize ?? 0) >= RISK_THRESHOLDS.minSampleSize;
    const hasSessionSample = (session.totalSessions ?? 0) > 0;

    let riskLevel;
    if (!hasSessionSample && !hasKnowledgeSample) {
      riskLevel = 'unknown';
    } else {
      const score = hasSessionSample ? session.avgScore : null;
      const decay = hasKnowledgeSample ? knowledge.decayRate : null;
      const highByScore = score !== null && score < RISK_THRESHOLDS.highScore;
      const highByDecay = decay !== null && decay > RISK_THRESHOLDS.highDecay;
      const medByScore = score !== null && score < RISK_THRESHOLDS.mediumScore;
      const medByDecay = decay !== null && decay > RISK_THRESHOLDS.mediumDecay;

      if (highByScore || highByDecay) riskLevel = 'high';
      else if (medByScore || medByDecay) riskLevel = 'medium';
      else riskLevel = 'low';
    }

    const report = await HrReport.create({
      companyId: req.user.companyId,
      generatedBy: req.user._id,
      reportType,
      periodStart: start,
      periodEnd: end,
      avgScore: session.avgScore ?? 0,
      decayRate: knowledge.decayRate ?? 0,
      riskLevel,
      reportData: {
        sessionStats: session,
        knowledgeStats: knowledge,
        departmentBreakdown,
      },
    });

    res.status(201).json({ success: true, data: report });
  } catch (err) {
    next(err);
  }
};

export const listReports = async (req, res, next) => {
  try {
    const filter = { companyId: req.user.companyId };
    if (req.query.reportType) filter.reportType = req.query.reportType;

    const reports = await HrReport.find(filter)
      .populate('generatedBy', 'fullName email')
      .sort({ createdAt: -1 })
      .limit(50);

    res.json({ success: true, data: reports });
  } catch (err) {
    next(err);
  }
};

export const getReport = async (req, res, next) => {
  try {
    const report = await HrReport.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    }).populate('generatedBy', 'fullName email');

    if (!report) throw ApiError.notFound('Report not found');

    res.json({ success: true, data: report });
  } catch (err) {
    next(err);
  }
};
