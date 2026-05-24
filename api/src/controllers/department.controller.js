import { Department } from '../models/Department.js';
import { User } from '../models/User.js';
import { ApiError } from '../utils/ApiError.js';
import { paginate, paginatedResponse } from '../utils/pagination.js';

const promoteManager = async (userId, companyId, departmentId) => {
  const user = await User.findOneAndUpdate(
    { _id: userId, companyId },
    { role: 'manager', departmentId },
    { new: true }
  );
  if (!user) throw ApiError.badRequest('Manager user not found in this company');
};

const demoteManager = async (userId, companyId) => {
  await User.updateOne(
    { _id: userId, companyId, role: 'manager' },
    { role: 'employee' }
  );
};

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

    if (managerId) {
      try {
        await promoteManager(managerId, req.user.companyId, dept._id);
      } catch (err) {
        await Department.deleteOne({ _id: dept._id });
        throw err;
      }
    }

    res.status(201).json({ success: true, data: dept });
  } catch (err) {
    next(err);
  }
};

export const updateDepartment = async (req, res, next) => {
  try {
    const { name, managerId } = req.body;
    const existing = await Department.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    });
    if (!existing) throw ApiError.notFound('Department not found');

    const nextManagerId = managerId || null;
    const previousManagerId = existing.managerId;

    existing.name = name ?? existing.name;
    existing.managerId = nextManagerId;
    await existing.save();

    if (previousManagerId && previousManagerId.toString() !== (nextManagerId ?? '').toString()) {
      await demoteManager(previousManagerId, req.user.companyId);
    }
    if (nextManagerId && nextManagerId.toString() !== (previousManagerId ?? '').toString()) {
      await promoteManager(nextManagerId, req.user.companyId, existing._id);
    }

    res.json({ success: true, data: existing });
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

    if (dept.managerId) await demoteManager(dept.managerId, req.user.companyId);
    await User.updateMany(
      { companyId: req.user.companyId, departmentId: dept._id },
      { departmentId: null }
    );

    res.json({ success: true, data: null });
  } catch (err) {
    next(err);
  }
};
