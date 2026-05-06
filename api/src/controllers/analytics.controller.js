import mongoose from 'mongoose';
import { UserAnswer } from '../models/UserAnswer.js';
import { TestSession } from '../models/TestSession.js';
import { User } from '../models/User.js';
import { UserKnowledgeProfile } from '../models/UserKnowledgeProfile.js';
import { HrReport } from '../models/HrReport.js';
import { ApiError } from '../utils/ApiError.js';

export const getCompanyOverview = async (req, res, next) => {
  try {
    const companyId = new mongoose.Types.ObjectId(req.user.companyId);

    const [sessionStats, topWrongQuestions] = await Promise.all([
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
    ]);

    res.json({
      success: true,
      data: {
        sessionStats: sessionStats[0] || {},
        topWrongQuestions,
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

    const [sessionHistory, wrongByCategory, weeklyTrend] = await Promise.all([
      TestSession.find({ userId, isCompleted: true })
        .sort({ completedAt: -1 })
        .limit(20)
        .select('weekNumber year scorePercent correctCount totalQuestions completedAt'),

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
            errorRate: { $multiply: [{ $divide: ['$wrong', '$total'] }, 100] },
          },
        },
        { $sort: { errorRate: -1 } },
      ]),

      TestSession.aggregate([
        { $match: { userId, isCompleted: true } },
        { $sort: { year: 1, weekNumber: 1 } },
        { $limit: 12 },
        {
          $project: {
            label: { $concat: ['Week ', { $toString: '$weekNumber' }, '/', { $toString: '$year' }] },
            score: '$scorePercent',
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
        {
          $group: {
            _id: null,
            avgMemoryStrength: { $avg: '$memoryStrength' },
            avgEasinessFactor: { $avg: '$easinessFactor' },
          },
        },
        {
          $project: {
            _id: 0,
            avgMemoryStrength: { $round: ['$avgMemoryStrength', 4] },
            decayRate: {
              $round: [{ $subtract: [1, '$avgMemoryStrength'] }, 4],
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
    const knowledge = knowledgeStats[0] ?? { avgMemoryStrength: 0, decayRate: 1 };

    const avgScore = session.avgScore ?? 0;
    const decayRate = knowledge.decayRate ?? 1;

    let riskLevel;
    if (avgScore < 40 || decayRate > 0.7) riskLevel = 'high';
    else if (avgScore < 70 || decayRate > 0.4) riskLevel = 'medium';
    else riskLevel = 'low';

    const report = await HrReport.create({
      companyId: req.user.companyId,
      generatedBy: req.user._id,
      reportType,
      periodStart: start,
      periodEnd: end,
      avgScore,
      decayRate,
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
