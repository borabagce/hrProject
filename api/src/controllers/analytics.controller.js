import mongoose from 'mongoose';
import { UserAnswer } from '../models/UserAnswer.js';
import { TestSession } from '../models/TestSession.js';
import { User } from '../models/User.js';
import { UserKnowledgeProfile } from '../models/UserKnowledgeProfile.js';
import { HrReport } from '../models/HrReport.js';
import { Test } from '../models/Test.js';
import { TestAssignment } from '../models/TestAssignment.js';
import { Question } from '../models/Question.js';
import { Department } from '../models/Department.js';
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

    const departmentRows = await Department.aggregate([
      { $match: { companyId } },
      {
        $lookup: {
          from: 'users',
          let: { deptId: '$_id' },
          pipeline: [
            { $match: { $expr: { $and: [
              { $eq: ['$departmentId', '$$deptId'] },
              { $eq: ['$companyId', companyId] },
              { $eq: ['$isActive', true] },
            ] } } },
            { $project: { _id: 1 } },
          ],
          as: 'users',
        },
      },
      {
        $lookup: {
          from: 'testsessions',
          let: { userIds: '$users._id' },
          pipeline: [
            { $match: { $expr: { $and: [
              { $in: ['$userId', '$$userIds'] },
              { $eq: ['$isCompleted', true] },
            ] } } },
            { $project: { scorePercent: 1 } },
          ],
          as: 'sessions',
        },
      },
      {
        $project: {
          _id: 1,
          departmentName: '$name',
          employeeCount: { $size: '$users' },
          totalSessions: { $size: '$sessions' },
          avgScore: {
            $cond: [
              { $eq: [{ $size: '$sessions' }, 0] },
              0,
              { $round: [{ $avg: '$sessions.scorePercent' }, 1] },
            ],
          },
        },
      },
      { $sort: { avgScore: -1, departmentName: 1 } },
    ]);

    const unassignedUsers = await User.aggregate([
      { $match: { companyId, departmentId: null, isActive: true } },
      { $project: { _id: 1 } },
    ]);

    if (unassignedUsers.length) {
      const unassignedUserIds = unassignedUsers.map((u) => u._id);
      const unassignedSessions = await TestSession.aggregate([
        { $match: { userId: { $in: unassignedUserIds }, isCompleted: true } },
        {
          $group: {
            _id: null,
            totalSessions: { $sum: 1 },
            avgScore: { $avg: '$scorePercent' },
          },
        },
      ]);
      const row = unassignedSessions[0] ?? { totalSessions: 0, avgScore: 0 };
      departmentRows.push({
        _id: null,
        departmentName: 'Departmansız',
        employeeCount: unassignedUsers.length,
        totalSessions: row.totalSessions,
        avgScore: row.totalSessions ? Math.round(row.avgScore * 10) / 10 : 0,
      });
    }

    res.json({ success: true, data: departmentRows });
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
            departmentName: { $ifNull: ['$department.name', 'Departmansız'] },
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

export const getTestAnalytics = async (req, res, next) => {
  try {
    const testId = new mongoose.Types.ObjectId(req.params.testId);
    const companyId = new mongoose.Types.ObjectId(req.user.companyId);

    const test = await Test.findOne({ _id: testId, companyId }).select('title type difficulty questionIds categoryId');
    if (!test) throw ApiError.notFound('Test not found');

    const assignments = await TestAssignment.aggregate([
      { $match: { testId, companyId } },
      {
        $lookup: {
          from: 'users',
          localField: 'assignedTo',
          foreignField: '_id',
          as: 'user',
        },
      },
      { $unwind: '$user' },
      {
        $lookup: {
          from: 'departments',
          localField: 'user.departmentId',
          foreignField: '_id',
          as: 'department',
        },
      },
      { $unwind: { path: '$department', preserveNullAndEmptyArrays: true } },
      {
        $lookup: {
          from: 'testsessions',
          localField: 'sessionId',
          foreignField: '_id',
          as: 'session',
        },
      },
      { $unwind: { path: '$session', preserveNullAndEmptyArrays: true } },
      {
        $project: {
          userId: '$user._id',
          fullName: '$user.fullName',
          departmentName: '$department.name',
          departmentId: '$user.departmentId',
          status: 1,
          completedAt: 1,
          scorePercent: '$session.scorePercent',
          correctCount: '$session.correctCount',
          totalQuestions: '$session.totalQuestions',
          isCompleted: '$session.isCompleted',
        },
      },
    ]);

    const completed = assignments.filter((a) => a.isCompleted);
    const scores = completed.map((a) => a.scorePercent ?? 0);
    const summary = {
      assignedCount: assignments.length,
      completedCount: completed.length,
      avgScore: scores.length ? scores.reduce((s, v) => s + v, 0) / scores.length : 0,
      maxScore: scores.length ? Math.max(...scores) : 0,
      minScore: scores.length ? Math.min(...scores) : 0,
    };

    const sessionIds = await TestAssignment.find({
      testId,
      companyId,
      sessionId: { $ne: null },
    }).distinct('sessionId');

    const questionStats = await UserAnswer.aggregate([
      {
        $match: {
          companyId,
          questionId: { $in: test.questionIds },
          sessionId: { $in: sessionIds },
        },
      },
      {
        $group: {
          _id: '$questionId',
          totalAttempts: { $sum: 1 },
          wrongCount: { $sum: { $cond: [{ $eq: ['$isCorrect', false] }, 1, 0] } },
        },
      },
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
          questionId: '$_id',
          _id: 0,
          text: '$question.text',
          totalAttempts: 1,
          wrongCount: 1,
          errorRate: {
            $round: [{ $multiply: [{ $divide: ['$wrongCount', '$totalAttempts'] }, 100] }, 1],
          },
        },
      },
      { $sort: { errorRate: -1 } },
    ]);

    const deptMap = new Map();
    for (const a of completed) {
      const key = a.departmentName ?? 'Departmansız';
      if (!deptMap.has(key)) deptMap.set(key, { completedCount: 0, total: 0 });
      const d = deptMap.get(key);
      d.completedCount += 1;
      d.total += a.scorePercent ?? 0;
    }
    const departmentBreakdown = Array.from(deptMap.entries()).map(([departmentName, v]) => ({
      departmentName,
      completedCount: v.completedCount,
      avgScore: v.completedCount ? v.total / v.completedCount : 0,
    })).sort((a, b) => b.avgScore - a.avgScore);

    res.json({
      success: true,
      data: {
        test: {
          _id: test._id,
          title: test.title,
          type: test.type,
          difficulty: test.difficulty,
          totalQuestions: test.questionIds.length,
        },
        summary,
        userPerformance: assignments,
        questionStats,
        departmentBreakdown,
      },
    });
  } catch (err) {
    next(err);
  }
};

export const getQuestionDetail = async (req, res, next) => {
  try {
    const questionId = new mongoose.Types.ObjectId(req.params.questionId);
    const companyId = new mongoose.Types.ObjectId(req.user.companyId);

    const question = await Question.findOne({ _id: questionId, companyId }).select('text type difficulty options categoryId');
    if (!question) throw ApiError.notFound('Question not found');

    const [summaryRow] = await UserAnswer.aggregate([
      { $match: { companyId, questionId } },
      {
        $group: {
          _id: null,
          totalAttempts: { $sum: 1 },
          wrongCount: { $sum: { $cond: [{ $eq: ['$isCorrect', false] }, 1, 0] } },
          avgResponseTime: { $avg: '$responseTimeSec' },
        },
      },
      {
        $project: {
          _id: 0,
          totalAttempts: 1,
          wrongCount: 1,
          avgResponseTime: { $ifNull: ['$avgResponseTime', 0] },
          errorRate: {
            $cond: [
              { $eq: ['$totalAttempts', 0] },
              0,
              { $multiply: [{ $divide: ['$wrongCount', '$totalAttempts'] }, 100] },
            ],
          },
        },
      },
    ]);

    const wrongAnswers = await UserAnswer.aggregate([
      { $match: { companyId, questionId, isCorrect: false } },
      { $sort: { answeredAt: -1 } },
      { $limit: 100 },
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
        $lookup: {
          from: 'departments',
          localField: 'user.departmentId',
          foreignField: '_id',
          as: 'department',
        },
      },
      { $unwind: { path: '$department', preserveNullAndEmptyArrays: true } },
      {
        $project: {
          _id: 0,
          userId: '$user._id',
          fullName: '$user.fullName',
          departmentName: '$department.name',
          selectedOptionOrder: 1,
          responseTimeSec: 1,
          answeredAt: 1,
        },
      },
    ]);

    res.json({
      success: true,
      data: {
        question,
        summary: summaryRow ?? { totalAttempts: 0, wrongCount: 0, avgResponseTime: 0, errorRate: 0 },
        wrongAnswers,
      },
    });
  } catch (err) {
    next(err);
  }
};

export const getDepartmentDetail = async (req, res, next) => {
  try {
    const departmentId = new mongoose.Types.ObjectId(req.params.departmentId);
    const companyId = new mongoose.Types.ObjectId(req.user.companyId);

    const department = await Department.findOne({ _id: departmentId, companyId });
    if (!department) throw ApiError.notFound('Department not found');

    const [employeeCount, sessions] = await Promise.all([
      User.countDocuments({ companyId, departmentId, isActive: true }),
      TestAssignment.aggregate([
        { $match: { companyId } },
        {
          $lookup: {
            from: 'users',
            localField: 'assignedTo',
            foreignField: '_id',
            as: 'user',
          },
        },
        { $unwind: '$user' },
        { $match: { 'user.departmentId': departmentId } },
        {
          $lookup: {
            from: 'testsessions',
            localField: 'sessionId',
            foreignField: '_id',
            as: 'session',
          },
        },
        { $unwind: { path: '$session', preserveNullAndEmptyArrays: true } },
        { $match: { 'session.isCompleted': true } },
        {
          $lookup: {
            from: 'tests',
            localField: 'testId',
            foreignField: '_id',
            as: 'test',
          },
        },
        { $unwind: '$test' },
        {
          $project: {
            _id: 0,
            userId: '$user._id',
            fullName: '$user.fullName',
            testId: '$test._id',
            testTitle: '$test.title',
            scorePercent: '$session.scorePercent',
          },
        },
      ]),
    ]);

    const scores = sessions.map((s) => s.scorePercent ?? 0);
    const summary = {
      employeeCount,
      totalSessions: sessions.length,
      avgScore: scores.length ? scores.reduce((s, v) => s + v, 0) / scores.length : 0,
    };

    const testMap = new Map();
    for (const s of sessions) {
      const key = s.testId.toString();
      if (!testMap.has(key)) testMap.set(key, { testId: s.testId, title: s.testTitle, scores: [] });
      testMap.get(key).scores.push(s.scorePercent ?? 0);
    }
    const testBreakdown = Array.from(testMap.values()).map((t) => ({
      testId: t.testId,
      title: t.title,
      completedCount: t.scores.length,
      avgScore: t.scores.reduce((s, v) => s + v, 0) / t.scores.length,
      maxScore: Math.max(...t.scores),
      minScore: Math.min(...t.scores),
    })).sort((a, b) => b.avgScore - a.avgScore);

    const userMap = new Map();
    for (const s of sessions) {
      const key = s.userId.toString();
      if (!userMap.has(key)) userMap.set(key, { userId: s.userId, fullName: s.fullName, scores: [] });
      userMap.get(key).scores.push(s.scorePercent ?? 0);
    }
    const userBreakdown = Array.from(userMap.values()).map((u) => ({
      userId: u.userId,
      fullName: u.fullName,
      completedCount: u.scores.length,
      avgScore: u.scores.reduce((s, v) => s + v, 0) / u.scores.length,
    })).sort((a, b) => b.avgScore - a.avgScore);

    res.json({
      success: true,
      data: {
        department: { _id: department._id, name: department.name },
        summary,
        testBreakdown,
        userBreakdown,
      },
    });
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
