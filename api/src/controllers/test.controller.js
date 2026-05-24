import { Test } from '../models/Test.js';
import { TestAssignment } from '../models/TestAssignment.js';
import { User } from '../models/User.js';
import { ApiError } from '../utils/ApiError.js';
import { paginate, paginatedResponse } from '../utils/pagination.js';

const isManager = (user) => user.role === 'manager';

const requireManagerDepartment = (user) => {
  if (!user.departmentId) throw ApiError.forbidden('Manager has no department assigned');
  return user.departmentId;
};

const resolveDepartmentScope = (user, requestedDepartmentId) => {
  if (isManager(user)) {
    const own = requireManagerDepartment(user).toString();
    if (requestedDepartmentId && requestedDepartmentId.toString() !== own) {
      throw ApiError.forbidden('Cannot target another department');
    }
    return user.departmentId;
  }
  return requestedDepartmentId ?? null;
};

export const getTests = async (req, res, next) => {
  try {
    const { page, limit, skip } = paginate(req.query);
    const filter = { companyId: req.user.companyId };

    if (req.query.categoryId) filter.categoryId = req.query.categoryId;

    if (req.user.role === 'employee') {
      filter.isActive = true;
    } else if (req.query.isActive !== undefined) {
      filter.isActive = req.query.isActive === 'true';
    }

    if (isManager(req.user)) {
      const own = requireManagerDepartment(req.user);
      filter.$or = [{ departmentId: own }, { departmentId: null }];
    } else if (req.query.departmentId) {
      filter.departmentId = req.query.departmentId;
    }

    const [tests, total] = await Promise.all([
      Test.find(filter)
        .populate('categoryId', 'name')
        .populate('departmentId', 'name')
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
      .populate('departmentId', 'name')
      .populate('createdBy', 'fullName')
      .populate('questionIds', 'text type difficulty options');
    if (!test) throw ApiError.notFound('Test not found');

    if (isManager(req.user) && test.departmentId) {
      const own = requireManagerDepartment(req.user).toString();
      if (test.departmentId._id.toString() !== own) throw ApiError.notFound('Test not found');
    }

    res.json({ success: true, data: test });
  } catch (err) {
    next(err);
  }
};

export const createTest = async (req, res, next) => {
  try {
    const { title, categoryId, departmentId, type, difficulty, questionIds, description } = req.body;
    const scopedDepartmentId = resolveDepartmentScope(req.user, departmentId);
    if (isManager(req.user) && !scopedDepartmentId) {
      throw ApiError.forbidden('Manager must create tests within own department');
    }

    const test = await Test.create({
      companyId: req.user.companyId,
      departmentId: scopedDepartmentId,
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
    const { title, categoryId, departmentId, type, difficulty, questionIds, description, isActive } = req.body;

    const test = await Test.findOne({ _id: req.params.id, companyId: req.user.companyId });
    if (!test) throw ApiError.notFound('Test not found');

    if (isManager(req.user)) {
      const own = requireManagerDepartment(req.user).toString();
      if (!test.departmentId || test.departmentId.toString() !== own) {
        throw ApiError.forbidden('Cannot modify test outside own department');
      }
      if (departmentId !== undefined && departmentId !== own) {
        throw ApiError.forbidden('Cannot change department');
      }
    } else if (departmentId !== undefined) {
      test.departmentId = departmentId || null;
    }

    if (title !== undefined) test.title = title;
    if (categoryId !== undefined) test.categoryId = categoryId || null;
    if (type !== undefined) test.type = type;
    if (difficulty !== undefined) test.difficulty = difficulty;
    if (questionIds !== undefined) test.questionIds = questionIds;
    if (description !== undefined) test.description = description;
    if (isActive !== undefined) test.isActive = isActive;

    await test.save();
    res.json({ success: true, data: test });
  } catch (err) {
    next(err);
  }
};

export const deleteTest = async (req, res, next) => {
  try {
    const test = await Test.findOne({ _id: req.params.id, companyId: req.user.companyId });
    if (!test) throw ApiError.notFound('Test not found');

    if (isManager(req.user)) {
      const own = requireManagerDepartment(req.user).toString();
      if (!test.departmentId || test.departmentId.toString() !== own) {
        throw ApiError.forbidden('Cannot delete test outside own department');
      }
    }

    test.isActive = false;
    await test.save();
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

    if (isManager(req.user)) {
      const own = requireManagerDepartment(req.user).toString();
      if (test.departmentId && test.departmentId.toString() !== own) {
        throw ApiError.forbidden('Cannot assign test outside own department');
      }
      const validCount = await User.countDocuments({
        _id: { $in: userIds },
        companyId: req.user.companyId,
        departmentId: req.user.departmentId,
        isActive: true,
      });
      if (validCount !== userIds.length) {
        throw ApiError.forbidden('All assignees must belong to your department');
      }
    }

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

    if (isManager(req.user)) {
      const own = requireManagerDepartment(req.user).toString();
      if (test.departmentId && test.departmentId.toString() !== own) {
        throw ApiError.forbidden('Cannot view assignments outside own department');
      }
    }

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
