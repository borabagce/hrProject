import { Category } from '../models/Category.js';
import { ApiError } from '../utils/ApiError.js';
import { paginate, paginatedResponse } from '../utils/pagination.js';

export const getCategories = async (req, res, next) => {
  try {
    const { page, limit, skip } = paginate(req.query);
    const filter = { companyId: req.user.companyId };

    const [categories, total] = await Promise.all([
      Category.find(filter).skip(skip).limit(limit),
      Category.countDocuments(filter),
    ]);

    res.json({ success: true, ...paginatedResponse(categories, total, page, limit) });
  } catch (err) {
    next(err);
  }
};

export const createCategory = async (req, res, next) => {
  try {
    const { name, description } = req.body;
    const category = await Category.create({
      companyId: req.user.companyId,
      name,
      description,
    });
    res.status(201).json({ success: true, data: category });
  } catch (err) {
    next(err);
  }
};

export const updateCategory = async (req, res, next) => {
  try {
    const { name, description } = req.body;
    const category = await Category.findOneAndUpdate(
      { _id: req.params.id, companyId: req.user.companyId },
      { name, description },
      { new: true, runValidators: true }
    );
    if (!category) throw ApiError.notFound('Category not found');
    res.json({ success: true, data: category });
  } catch (err) {
    next(err);
  }
};

export const deleteCategory = async (req, res, next) => {
  try {
    const category = await Category.findOneAndDelete({
      _id: req.params.id,
      companyId: req.user.companyId,
    });
    if (!category) throw ApiError.notFound('Category not found');
    res.json({ success: true, data: null });
  } catch (err) {
    next(err);
  }
};
