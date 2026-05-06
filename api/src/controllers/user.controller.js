import { User } from '../models/User.js';
import { ApiError } from '../utils/ApiError.js';
import { paginate, paginatedResponse } from '../utils/pagination.js';

export const getUsers = async (req, res, next) => {
  try {
    const { page, limit, skip } = paginate(req.query);
    const filter = { companyId: req.user.companyId };

    if (req.query.role) filter.role = req.query.role;
    if (req.query.departmentId) filter.departmentId = req.query.departmentId;
    if (req.query.isActive !== undefined) filter.isActive = req.query.isActive === 'true';

    const [users, total] = await Promise.all([
      User.find(filter).populate('departmentId', 'name').skip(skip).limit(limit),
      User.countDocuments(filter),
    ]);

    res.json({ success: true, ...paginatedResponse(users, total, page, limit) });
  } catch (err) {
    next(err);
  }
};

export const getUser = async (req, res, next) => {
  try {
    const user = await User.findOne({
      _id: req.params.id,
      companyId: req.user.companyId,
    }).populate('departmentId', 'name');

    if (!user) throw ApiError.notFound('User not found');
    res.json({ success: true, data: user });
  } catch (err) {
    next(err);
  }
};

export const createUser = async (req, res, next) => {
  try {
    const { fullName, email, password, role, departmentId } = req.body;

    const existing = await User.findOne({ email });
    if (existing) throw ApiError.conflict('Email already registered');

    const user = await User.create({
      companyId: req.user.companyId,
      fullName,
      email,
      passwordHash: password,
      role: role || 'employee',
      departmentId: departmentId || null,
    });

    res.status(201).json({ success: true, data: user });
  } catch (err) {
    next(err);
  }
};

export const updateUser = async (req, res, next) => {
  try {
    const { fullName, role, departmentId, isActive } = req.body;
    const user = await User.findOneAndUpdate(
      { _id: req.params.id, companyId: req.user.companyId },
      { fullName, role, departmentId: departmentId || null, isActive },
      { new: true, runValidators: true }
    );
    if (!user) throw ApiError.notFound('User not found');
    res.json({ success: true, data: user });
  } catch (err) {
    next(err);
  }
};

export const updateMyProfile = async (req, res, next) => {
  try {
    const { fullName } = req.body;
    const user = await User.findByIdAndUpdate(
      req.user._id,
      { fullName },
      { new: true, runValidators: true }
    );
    res.json({ success: true, data: user });
  } catch (err) {
    next(err);
  }
};

export const changeMyPassword = async (req, res, next) => {
  try {
    const { currentPassword, newPassword } = req.body;

    const user = await User.findById(req.user._id).select('+passwordHash');
    const match = await user.comparePassword(currentPassword);
    if (!match) throw ApiError.badRequest('Current password is incorrect');

    user.passwordHash = newPassword;
    await user.save();

    res.json({ success: true, data: null });
  } catch (err) {
    next(err);
  }
};
