import mongoose from 'mongoose';
import { UserKnowledgeProfile } from '../models/UserKnowledgeProfile.js';
import { ApiError } from '../utils/ApiError.js';

export const getMyKnowledgeOverview = async (req, res, next) => {
  try {
    const userId = new mongoose.Types.ObjectId(req.user._id);
    const now = new Date();

    const [overview, weakest] = await Promise.all([
      UserKnowledgeProfile.aggregate([
        { $match: { userId } },
        {
          $group: {
            _id: null,
            totalTracked: { $sum: 1 },
            dueCount: { $sum: { $cond: [{ $lte: ['$nextReviewDate', now] }, 1, 0] } },
            avgMemoryStrength: { $avg: '$memoryStrength' },
            avgEasinessFactor: { $avg: '$easinessFactor' },
          },
        },
        {
          $project: {
            _id: 0,
            totalTracked: 1,
            dueCount: 1,
            avgMemoryStrength: { $round: ['$avgMemoryStrength', 4] },
            avgEasinessFactor: { $round: ['$avgEasinessFactor', 2] },
          },
        },
      ]),
      UserKnowledgeProfile.find({ userId, memoryStrength: { $lt: 0.4 } })
        .sort({ memoryStrength: 1 })
        .limit(10)
        .populate('questionId', 'text difficulty categoryId'),
    ]);

    res.json({
      success: true,
      data: {
        overview: overview[0] ?? { totalTracked: 0, dueCount: 0, avgMemoryStrength: 0, avgEasinessFactor: 2.5 },
        weakest,
      },
    });
  } catch (err) {
    next(err);
  }
};

export const getMyDueQuestions = async (req, res, next) => {
  try {
    const userId = new mongoose.Types.ObjectId(req.user._id);
    const limit = Math.min(parseInt(req.query.limit) || 10, 50);
    const now = new Date();

    const due = await UserKnowledgeProfile.find({ userId, nextReviewDate: { $lte: now } })
      .sort({ nextReviewDate: 1, memoryStrength: 1 })
      .limit(limit)
      .populate('questionId', 'text type difficulty categoryId options');

    const result = due.map((profile) => ({
      profileId: profile._id,
      memoryStrength: profile.memoryStrength,
      intervalDays: profile.intervalDays,
      daysPastDue: Math.floor((now - profile.nextReviewDate) / 86400000),
      question: {
        ...profile.questionId.toObject(),
        options: profile.questionId.options.map(({ text, order }) => ({ text, order })),
      },
    }));

    res.json({ success: true, data: result });
  } catch (err) {
    next(err);
  }
};

export const getCompanyKnowledgeStats = async (req, res, next) => {
  try {
    const companyId = new mongoose.Types.ObjectId(req.user.companyId);
    const now = new Date();

    const stats = await UserKnowledgeProfile.aggregate([
      { $match: { companyId } },
      {
        $group: {
          _id: '$userId',
          avgMemoryStrength: { $avg: '$memoryStrength' },
          dueCount: { $sum: { $cond: [{ $lte: ['$nextReviewDate', now] }, 1, 0] } },
          totalTracked: { $sum: 1 },
        },
      },
      {
        $lookup: {
          from: 'users',
          localField: '_id',
          foreignField: '_id',
          as: 'user',
        },
      },
      { $unwind: '$user' },
      {
        $project: {
          userId: '$_id',
          _id: 0,
          fullName: '$user.fullName',
          departmentId: '$user.departmentId',
          avgMemoryStrength: { $round: ['$avgMemoryStrength', 4] },
          dueCount: 1,
          totalTracked: 1,
        },
      },
      { $sort: { avgMemoryStrength: 1 } },
    ]);

    res.json({ success: true, data: stats });
  } catch (err) {
    next(err);
  }
};

export const getEmployeeKnowledgeProfile = async (req, res, next) => {
  try {
    const userId = new mongoose.Types.ObjectId(req.params.userId);
    const companyId = new mongoose.Types.ObjectId(req.user.companyId);
    const now = new Date();

    const profileExists = await UserKnowledgeProfile.exists({ userId, companyId });
    if (!profileExists) throw ApiError.notFound('Knowledge profile not found');

    const [overview, byCategory] = await Promise.all([
      UserKnowledgeProfile.aggregate([
        { $match: { userId, companyId } },
        {
          $group: {
            _id: null,
            totalTracked: { $sum: 1 },
            dueCount: { $sum: { $cond: [{ $lte: ['$nextReviewDate', now] }, 1, 0] } },
            avgMemoryStrength: { $avg: '$memoryStrength' },
            avgEasinessFactor: { $avg: '$easinessFactor' },
          },
        },
        {
          $project: {
            _id: 0,
            totalTracked: 1,
            dueCount: 1,
            avgMemoryStrength: { $round: ['$avgMemoryStrength', 4] },
            avgEasinessFactor: { $round: ['$avgEasinessFactor', 2] },
          },
        },
      ]),
      UserKnowledgeProfile.aggregate([
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
            avgMemoryStrength: { $avg: '$memoryStrength' },
            questionCount: { $sum: 1 },
            dueCount: { $sum: { $cond: [{ $lte: ['$nextReviewDate', now] }, 1, 0] } },
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
            avgMemoryStrength: { $round: ['$avgMemoryStrength', 4] },
            questionCount: 1,
            dueCount: 1,
          },
        },
        { $sort: { avgMemoryStrength: 1 } },
      ]),
    ]);

    res.json({
      success: true,
      data: {
        overview: overview[0] ?? {},
        byCategory,
      },
    });
  } catch (err) {
    next(err);
  }
};
