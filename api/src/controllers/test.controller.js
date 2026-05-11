import { Test } from '../models/Test.js';
import { TestAssignment } from '../models/TestAssignment.js';
import { ApiError } from '../utils/ApiError.js';
import { paginate, paginatedResponse } from '../utils/pagination.js';

export const getTests = async (req, res, next) => {
  try {
    const { page, limit, skip } = paginate(req.query);
    const filter = { companyId: req.user.companyId };

    if (req.query.categoryId) filter.categoryId = req.query.categoryId;

    if (req.user.role === 'employee') filter.isActive = true;
    else if (req.query.isActive !== undefined) filter.isActive = req.query.isActive === 'true';

    const [tests, total] = await Promise.all([
      Test.find(filter)
        .populate('categoryId', 'name')
        .populate('createdBy', 'fullName')
        .skip(skip)
        .limit(limit),
      Test.countDocuments(filter),
    ]);

    res.json({ success: true, ...paginatedResponse(tests, total, page, limit) });
  } catch (err) {
    next(err);
  }
};

export const getTest = async (req, res, next) => {
  try {
    const filter = { _id: req.params.id, companyId: req.user.companyId };
    if (req.user.role === 'employee') filter.isActive = true;

    const test = await Test.findOne(filter)
      .populate('categoryId', 'name')
      .populate('createdBy', 'fullName')
      .populate('questionIds', 'text type difficulty options');
    if (!test) throw ApiError.notFound('Test not found');

    res.json({ success: true, data: test });
  } catch (err) {
    next(err);
  }
};

export const createTest = async (req, res, next) => {
  try {
    const { title, categoryId, type, difficulty, questionIds, description } = req.body;

    const test = await Test.create({
      companyId: req.user.companyId,
      createdBy: req.user._id,
      title,
      categoryId: categoryId ?? null,
      type,
      difficulty,
      questionIds: questionIds ?? [],
      description: description ?? null,
    });

    res.status(201).json({ success: true, data: test });
  } catch (err) {
    next(err);
  }
};

export const updateTest = async (req, res, next) => {
  try {
    const { title, categoryId, type, difficulty, questionIds, description, isActive } = req.body;

    const test = await Test.findOneAndUpdate(
      { _id: req.params.id, companyId: req.user.companyId },
      { title, categoryId, type, difficulty, questionIds, description, isActive },
      { new: true, runValidators: true }
    );
    if (!test) throw ApiError.notFound('Test not found');

    res.json({ success: true, data: test });
  } catch (err) {
    next(err);
  }
};

export const deleteTest = async (req, res, next) => {
  try {
    const test = await Test.findOneAndUpdate(
      { _id: req.params.id, companyId: req.user.companyId },
      { isActive: false },
      { new: true }
    );
    if (!test) throw ApiError.notFound('Test not found');

    res.json({ success: true, data: null });
  } catch (err) {
    next(err);
  }
};

export const assignTest = async (req, res, next) => {
  try {
    const test = await Test.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
      isActive: true,
    });
    if (!test) throw ApiError.notFound('Test not found');

    const { userIds, dueDate } = req.body;

    const docs = userIds.map((userId) => ({
      companyId: req.user.companyId,
      testId: test._id,
      assignedTo: userId,
      assignedBy: req.user._id,
      dueDate: dueDate ?? null,
    }));

    let insertedCount = 0;
    try {
      const result = await TestAssignment.insertMany(docs, { ordered: false });
      insertedCount = result.length;
    } catch (err) {
      if (err.name !== 'MongoBulkWriteError') throw err;
      insertedCount = err.result?.insertedCount ?? 0;
    }

    res.status(201).json({
      success: true,
      data: { assigned: insertedCount, skipped: userIds.length - insertedCount },
    });
  } catch (err) {
    next(err);
  }
};

export const getTestAssignments = async (req, res, next) => {
  try {
    const test = await Test.findOne({ _id: req.params.id, companyId: req.user.companyId });
    if (!test) throw ApiError.notFound('Test not found');

    const assignments = await TestAssignment.find({
      testId: test._id,
      companyId: req.user.companyId,
    })
      .populate('assignedTo', 'fullName email')
      .populate('assignedBy', 'fullName');

    res.json({ success: true, data: assignments });
  } catch (err) {
    next(err);
  }
};
