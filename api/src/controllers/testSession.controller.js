import mongoose from 'mongoose';
import { TestSession } from '../models/TestSession.js';
import { UserAnswer } from '../models/UserAnswer.js';
import { Question } from '../models/Question.js';
import { UserKnowledgeProfile } from '../models/UserKnowledgeProfile.js';
import { deriveQuality, computeSm2, defaultProfile } from '../services/sm2.js';
import { ApiError } from '../utils/ApiError.js';
import { paginate, paginatedResponse } from '../utils/pagination.js';

export const startSession = async (req, res, next) => {
  try {
    const { questionCount = 10, categoryId } = req.body;
    const { week, year } = TestSession.getWeekNumber();

    const existingSession = await TestSession.findOne({
      userId: req.user._id,
      weekNumber: week,
      year,
      sessionType: 'weekly',
      isCompleted: false,
    });
    if (existingSession) {
      return res.json({ success: true, data: existingSession });
    }

    const matchFilter = { companyId: req.user.companyId, isActive: true };
    if (categoryId) matchFilter.categoryId = new mongoose.Types.ObjectId(categoryId);

    const questions = await Question.aggregate([
      { $match: matchFilter },
      { $sample: { size: parseInt(questionCount) } },
      { $project: { _id: 1 } },
    ]);

    if (questions.length === 0) throw ApiError.badRequest('No active questions available');

    const session = await TestSession.create({
      userId: req.user._id,
      companyId: req.user.companyId,
      weekNumber: week,
      year,
      questionIds: questions.map((q) => q._id),
      totalQuestions: questions.length,
      sessionType: 'weekly',
    });

    res.status(201).json({ success: true, data: session });
  } catch (err) {
    next(err);
  }
};

export const startReviewSession = async (req, res, next) => {
  try {
    const userId = new mongoose.Types.ObjectId(req.user._id);
    const limit = Math.min(parseInt(req.body.questionCount) || 10, 30);
    const now = new Date();
    const { week, year } = TestSession.getWeekNumber();

    const dueProfiles = await UserKnowledgeProfile.find({
      userId,
      nextReviewDate: { $lte: now },
    })
      .sort({ nextReviewDate: 1, memoryStrength: 1 })
      .limit(limit)
      .select('questionId');

    if (dueProfiles.length === 0) {
      return res.json({ success: true, data: null, message: 'No questions due for review' });
    }

    const session = await TestSession.create({
      userId: req.user._id,
      companyId: req.user.companyId,
      weekNumber: week,
      year,
      questionIds: dueProfiles.map((p) => p.questionId),
      totalQuestions: dueProfiles.length,
      sessionType: 'review',
    });

    res.status(201).json({ success: true, data: session });
  } catch (err) {
    next(err);
  }
};

export const getSessionQuestions = async (req, res, next) => {
  try {
    const session = await TestSession.findOne({
      _id: req.params.id,
      userId: req.user._id,
    });
    if (!session) throw ApiError.notFound('Session not found');
    if (session.isCompleted) throw ApiError.badRequest('Session already completed');

    const answeredIds = await UserAnswer.find({ sessionId: session._id }).distinct('questionId');

    const questions = await Question.find({
      _id: { $in: session.questionIds },
    }).select('text type difficulty categoryId options');

    const sanitized = questions.map((q) => {
      const isAnswered = answeredIds.some((id) => id.equals(q._id));
      return {
        ...q.toObject(),
        options: isAnswered
          ? q.options
          : q.options.map(({ text, order }) => ({ text, order })),
        isAnswered,
      };
    });

    res.json({ success: true, data: { session, questions: sanitized } });
  } catch (err) {
    next(err);
  }
};

export const submitAnswer = async (req, res, next) => {
  try {
    const { questionId, selectedOptionOrder, responseTimeSec } = req.body;

    const session = await TestSession.findOne({
      _id: req.params.id,
      userId: req.user._id,
      isCompleted: false,
    });
    if (!session) throw ApiError.notFound('Active session not found');

    if (!session.questionIds.some((id) => id.equals(questionId))) {
      throw ApiError.badRequest('Question not part of this session');
    }

    const alreadyAnswered = await UserAnswer.findOne({ sessionId: session._id, questionId });
    if (alreadyAnswered) throw ApiError.conflict('Question already answered');

    const question = await Question.findById(questionId).select('options');
    const correctOption = question.options.find((o) => o.isCorrect);
    const isCorrect = correctOption.order === selectedOptionOrder;

    await UserAnswer.create({
      sessionId: session._id,
      userId: req.user._id,
      companyId: req.user.companyId,
      questionId,
      selectedOptionOrder,
      isCorrect,
      responseTimeSec: responseTimeSec ?? null,
    });

    const quality = deriveQuality(isCorrect, responseTimeSec ?? null);
    const existing = await UserKnowledgeProfile.findOne({
      userId: req.user._id,
      questionId,
    }).lean();

    const base = existing ?? defaultProfile();
    const sm2Result = computeSm2(base, quality);

    await UserKnowledgeProfile.findOneAndUpdate(
      { userId: req.user._id, questionId },
      {
        $set: {
          ...sm2Result,
          companyId: req.user.companyId,
        },
      },
      { upsert: true }
    );

    const answeredCount = await UserAnswer.countDocuments({ sessionId: session._id });

    if (answeredCount >= session.totalQuestions) {
      const correctCount = await UserAnswer.countDocuments({
        sessionId: session._id,
        isCorrect: true,
      });
      const scorePercent = Math.round((correctCount / session.totalQuestions) * 100);

      await TestSession.findByIdAndUpdate(session._id, {
        correctCount,
        scorePercent,
        completedAt: new Date(),
        isCompleted: true,
      });
    }

    res.json({ success: true, data: { isCorrect, correctOptionOrder: correctOption.order } });
  } catch (err) {
    next(err);
  }
};

export const getSessionResult = async (req, res, next) => {
  try {
    const session = await TestSession.findOne({
      _id: req.params.id,
      userId: req.user._id,
      isCompleted: true,
    });
    if (!session) throw ApiError.notFound('Completed session not found');

    const answers = await UserAnswer.find({ sessionId: session._id }).populate(
      'questionId',
      'text options categoryId difficulty'
    );

    res.json({ success: true, data: { session, answers } });
  } catch (err) {
    next(err);
  }
};

export const getMySessions = async (req, res, next) => {
  try {
    const { page, limit, skip } = paginate(req.query);
    const filter = { userId: req.user._id };
    if (req.query.isCompleted !== undefined) filter.isCompleted = req.query.isCompleted === 'true';
    if (req.query.sessionType) filter.sessionType = req.query.sessionType;

    const [sessions, total] = await Promise.all([
      TestSession.find(filter).sort({ createdAt: -1 }).skip(skip).limit(limit),
      TestSession.countDocuments(filter),
    ]);

    res.json({ success: true, ...paginatedResponse(sessions, total, page, limit) });
  } catch (err) {
    next(err);
  }
};

export const getCompanySessions = async (req, res, next) => {
  try {
    const { page, limit, skip } = paginate(req.query);
    const filter = { companyId: req.user.companyId };

    if (req.query.userId) filter.userId = req.query.userId;
    if (req.query.year) filter.year = parseInt(req.query.year);
    if (req.query.weekNumber) filter.weekNumber = parseInt(req.query.weekNumber);
    if (req.query.isCompleted !== undefined) filter.isCompleted = req.query.isCompleted === 'true';
    if (req.query.sessionType) filter.sessionType = req.query.sessionType;

    const [sessions, total] = await Promise.all([
      TestSession.find(filter)
        .populate('userId', 'fullName email departmentId')
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit),
      TestSession.countDocuments(filter),
    ]);

    res.json({ success: true, ...paginatedResponse(sessions, total, page, limit) });
  } catch (err) {
    next(err);
  }
};
