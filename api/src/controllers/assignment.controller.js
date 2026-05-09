import { TestAssignment } from '../models/TestAssignment.js';
import { TestSession } from '../models/TestSession.js';
import { Test } from '../models/Test.js';
import { ApiError } from '../utils/ApiError.js';
import { paginate, paginatedResponse } from '../utils/pagination.js';

export const getMyAssignments = async (req, res, next) => {
  try {
    const filter = {
      companyId: req.user.companyId,
      assignedTo: req.user._id,
    };

    if (req.query.status) filter.status = req.query.status;

    const assignments = await TestAssignment.find(filter)
      .populate('testId', 'title type difficulty')
      .populate('assignedBy', 'fullName');

    res.json({ success: true, data: assignments });
  } catch (err) {
    next(err);
  }
};

export const getAssignments = async (req, res, next) => {
  try {
    const { page, limit, skip } = paginate(req.query);
    const filter = { companyId: req.user.companyId };

    if (req.query.testId) filter.testId = req.query.testId;
    if (req.query.assignedTo) filter.assignedTo = req.query.assignedTo;
    if (req.query.status) filter.status = req.query.status;

    const [assignments, total] = await Promise.all([
      TestAssignment.find(filter)
        .populate('testId', 'title type difficulty')
        .populate('assignedTo', 'fullName email')
        .populate('assignedBy', 'fullName')
        .skip(skip)
        .limit(limit),
      TestAssignment.countDocuments(filter),
    ]);

    res.json({ success: true, ...paginatedResponse(assignments, total, page, limit) });
  } catch (err) {
    next(err);
  }
};

export const startAssignment = async (req, res, next) => {
  try {
    const assignment = await TestAssignment.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
      assignedTo: req.user._id,
    });
    if (!assignment) throw ApiError.notFound('Assignment not found');
    if (!['pending', 'in_progress'].includes(assignment.status)) {
      throw ApiError.badRequest('Assignment cannot be started');
    }

    if (assignment.status === 'in_progress' && assignment.sessionId) {
      const existing = await TestSession.findById(assignment.sessionId);
      return res.json({ success: true, data: existing });
    }

    const test = await Test.findOne({ _id: assignment.testId, companyId: req.user.companyId });
    if (!test) throw ApiError.notFound('Test not found');

    const { week, year } = TestSession.getWeekNumber();

    const session = await TestSession.create({
      userId: req.user._id,
      companyId: req.user.companyId,
      weekNumber: week,
      year,
      questionIds: test.questionIds,
      totalQuestions: test.questionIds.length,
      sessionType: 'weekly',
    });

    assignment.status = 'in_progress';
    assignment.sessionId = session._id;
    await assignment.save();

    res.status(201).json({ success: true, data: session });
  } catch (err) {
    next(err);
  }
};

export const completeAssignment = async (req, res, next) => {
  try {
    const assignment = await TestAssignment.findOneAndUpdate(
      {
        _id: req.params.id,
        companyId: req.user.companyId,
        assignedTo: req.user._id,
      },
      { status: 'completed', completedAt: new Date() },
      { new: true }
    );
    if (!assignment) throw ApiError.notFound('Assignment not found');

    res.json({ success: true, data: assignment });
  } catch (err) {
    next(err);
  }
};
