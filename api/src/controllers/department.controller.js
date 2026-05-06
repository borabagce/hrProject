import { Department } from '../models/Department.js';
import { ApiError } from '../utils/ApiError.js';
import { paginate, paginatedResponse } from '../utils/pagination.js';

export const getDepartments = async (req, res, next) => {
  try {
    const { page, limit, skip } = paginate(req.query);
    const filter = { companyId: req.user.companyId };

    const [departments, total] = await Promise.all([
      Department.find(filter).populate('managerId', 'fullName email').skip(skip).limit(limit),
      Department.countDocuments(filter),
    ]);

    res.json({ success: true, ...paginatedResponse(departments, total, page, limit) });
  } catch (err) {
    next(err);
  }
};

export const getDepartment = async (req, res, next) => {
  try {
    const dept = await Department.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    }).populate('managerId', 'fullName email');

    if (!dept) throw ApiError.notFound('Department not found');
    res.json({ success: true, data: dept });
  } catch (err) {
    next(err);
  }
};

export const createDepartment = async (req, res, next) => {
  try {
    const { name, managerId } = req.body;
    const dept = await Department.create({
      companyId: req.user.companyId,
      name,
      managerId: managerId || null,
    });
    res.status(201).json({ success: true, data: dept });
  } catch (err) {
    next(err);
  }
};

export const updateDepartment = async (req, res, next) => {
  try {
    const { name, managerId } = req.body;
    const dept = await Department.findOneAndUpdate(
      { _id: req.params.id, companyId: req.user.companyId },
      { name, managerId: managerId || null },
      { new: true, runValidators: true }
    );
    if (!dept) throw ApiError.notFound('Department not found');
    res.json({ success: true, data: dept });
  } catch (err) {
    next(err);
  }
};

export const deleteDepartment = async (req, res, next) => {
  try {
    const dept = await Department.findOneAndDelete({
      _id: req.params.id,
      companyId: req.user.companyId,
    });
    if (!dept) throw ApiError.notFound('Department not found');
    res.json({ success: true, data: null });
  } catch (err) {
    next(err);
  }
};
