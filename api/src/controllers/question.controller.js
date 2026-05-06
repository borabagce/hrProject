import { Question } from '../models/Question.js';
import { ApiError } from '../utils/ApiError.js';
import { paginate, paginatedResponse } from '../utils/pagination.js';

export const getQuestions = async (req, res, next) => {
  try {
    const { page, limit, skip } = paginate(req.query);
    const filter = { companyId: req.user.companyId };

    if (req.query.categoryId) filter.categoryId = req.query.categoryId;
    if (req.query.difficulty) filter.difficulty = parseInt(req.query.difficulty);
    if (req.query.type) filter.type = req.query.type;

    if (req.user.role === 'employee') filter.isActive = true;
    else if (req.query.isActive !== undefined) filter.isActive = req.query.isActive === 'true';

    const [questions, total] = await Promise.all([
      Question.find(filter)
        .populate('categoryId', 'name')
        .populate('createdBy', 'fullName')
        .skip(skip)
        .limit(limit),
      Question.countDocuments(filter),
    ]);

    res.json({ success: true, ...paginatedResponse(questions, total, page, limit) });
  } catch (err) {
    next(err);
  }
};

export const getQuestion = async (req, res, next) => {
  try {
    const filter = { _id: req.params.id, companyId: req.user.companyId };
    if (req.user.role === 'employee') filter.isActive = true;

    const question = await Question.findOne(filter)
      .populate('categoryId', 'name')
      .populate('createdBy', 'fullName');
    if (!question) throw ApiError.notFound('Question not found');

    res.json({ success: true, data: question });
  } catch (err) {
    next(err);
  }
};

export const createQuestion = async (req, res, next) => {
  try {
    const { categoryId, text, type, difficulty, options } = req.body;

    const question = await Question.create({
      companyId: req.user.companyId,
      categoryId,
      createdBy: req.user._id,
      text,
      type,
      difficulty,
      options,
    });

    res.status(201).json({ success: true, data: question });
  } catch (err) {
    next(err);
  }
};

export const updateQuestion = async (req, res, next) => {
  try {
    const { text, type, difficulty, options, isActive, categoryId } = req.body;
    const question = await Question.findOneAndUpdate(
      { _id: req.params.id, companyId: req.user.companyId },
      { text, type, difficulty, options, isActive, categoryId },
      { new: true, runValidators: true }
    );
    if (!question) throw ApiError.notFound('Question not found');
    res.json({ success: true, data: question });
  } catch (err) {
    next(err);
  }
};

export const deleteQuestion = async (req, res, next) => {
  try {
    const question = await Question.findOneAndUpdate(
      { _id: req.params.id, companyId: req.user.companyId },
      { isActive: false },
      { new: true }
    );
    if (!question) throw ApiError.notFound('Question not found');
    res.json({ success: true, data: null });
  } catch (err) {
    next(err);
  }
};
