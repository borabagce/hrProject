import mongoose from 'mongoose';
import { SystemAdmin } from '../models/SystemAdmin.js';
import { Company } from '../models/Company.js';
import { User } from '../models/User.js';
import { signAccessToken, signRefreshToken, verifyRefreshToken } from '../utils/jwt.js';
import { ApiError } from '../utils/ApiError.js';
import { paginate, paginatedResponse } from '../utils/pagination.js';

const tokenPayload = (admin) => ({
  sub: admin._id.toString(),
  kind: 'system',
});

export const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const admin = await SystemAdmin.findOne({ email, isActive: true }).select('+passwordHash');
    if (!admin) throw ApiError.unauthorized('Invalid credentials');

    const match = await admin.comparePassword(password);
    if (!match) throw ApiError.unauthorized('Invalid credentials');

    const [accessToken, refreshToken] = await Promise.all([
      signAccessToken(tokenPayload(admin)),
      signRefreshToken(tokenPayload(admin)),
    ]);

    res.json({ success: true, data: { admin, accessToken, refreshToken } });
  } catch (err) {
    next(err);
  }
};

export const refreshToken = async (req, res, next) => {
  try {
    const { refreshToken: token } = req.body;
    if (!token) throw ApiError.badRequest('Refresh token required');

    let payload;
    try {
      payload = await verifyRefreshToken(token);
    } catch {
      throw ApiError.unauthorized('Invalid refresh token');
    }

    if (payload.kind !== 'system') throw ApiError.unauthorized();

    const admin = await SystemAdmin.findById(payload.sub);
    if (!admin || !admin.isActive) throw ApiError.unauthorized();

    const [accessToken, newRefreshToken] = await Promise.all([
      signAccessToken(tokenPayload(admin)),
      signRefreshToken(tokenPayload(admin)),
    ]);

    res.json({ success: true, data: { accessToken, refreshToken: newRefreshToken } });
  } catch (err) {
    next(err);
  }
};

export const getMe = async (req, res) => {
  res.json({ success: true, data: req.systemAdmin });
};

export const listCompanies = async (req, res, next) => {
  try {
    const { page, limit, skip } = paginate(req.query);
    const search = req.query.search?.trim();

    const match = {};
    if (search) match.name = { $regex: search, $options: 'i' };
    if (req.query.isActive !== undefined) match.isActive = req.query.isActive === 'true';

    const [items, total] = await Promise.all([
      Company.aggregate([
        { $match: match },
        { $sort: { createdAt: -1 } },
        { $skip: skip },
        { $limit: limit },
        {
          $lookup: {
            from: 'users',
            let: { cid: '$_id' },
            pipeline: [
              { $match: { $expr: { $eq: ['$companyId', '$$cid'] } } },
              {
                $group: {
                  _id: '$role',
                  count: { $sum: 1 },
                  active: { $sum: { $cond: ['$isActive', 1, 0] } },
                },
              },
            ],
            as: 'roleStats',
          },
        },
        {
          $addFields: {
            employeeCount: {
              $sum: {
                $map: { input: '$roleStats', as: 'r', in: '$$r.count' },
              },
            },
            activeEmployeeCount: {
              $sum: {
                $map: { input: '$roleStats', as: 'r', in: '$$r.active' },
              },
            },
          },
        },
      ]),
      Company.countDocuments(match),
    ]);

    res.json({ success: true, ...paginatedResponse(items, total, page, limit) });
  } catch (err) {
    next(err);
  }
};

export const getCompany = async (req, res, next) => {
  try {
    const companyId = new mongoose.Types.ObjectId(req.params.id);

    const [company, roleStats] = await Promise.all([
      Company.findById(companyId),
      User.aggregate([
        { $match: { companyId } },
        {
          $group: {
            _id: '$role',
            count: { $sum: 1 },
            active: { $sum: { $cond: ['$isActive', 1, 0] } },
          },
        },
      ]),
    ]);

    if (!company) throw ApiError.notFound('Company not found');

    res.json({ success: true, data: { company, roleStats } });
  } catch (err) {
    next(err);
  }
};

export const createCompany = async (req, res, next) => {
  let createdCompanyId;
  try {
    const {
      name,
      industry,
      subscriptionPlan,
      maxEmployees,
      adminFullName,
      adminEmail,
      adminPassword,
      adminRole,
    } = req.body;

    const existing = await User.findOne({ email: adminEmail });
    if (existing) throw ApiError.conflict('Email already registered');

    const company = await Company.create({ name, industry, subscriptionPlan, maxEmployees });
    createdCompanyId = company._id;

    const initialUser = await User.create({
      companyId: company._id,
      fullName: adminFullName,
      email: adminEmail,
      passwordHash: adminPassword,
      role: adminRole,
    });

    res.status(201).json({ success: true, data: { company, initialUser } });
  } catch (err) {
    if (createdCompanyId) {
      await Company.deleteOne({ _id: createdCompanyId }).catch(() => {});
    }
    next(err);
  }
};

export const updateCompany = async (req, res, next) => {
  try {
    const { name, industry, subscriptionPlan, maxEmployees, isActive } = req.body;
    const company = await Company.findByIdAndUpdate(
      req.params.id,
      { name, industry, subscriptionPlan, maxEmployees, isActive },
      { new: true, runValidators: true }
    );
    if (!company) throw ApiError.notFound('Company not found');
    res.json({ success: true, data: company });
  } catch (err) {
    next(err);
  }
};

export const getStats = async (_req, res, next) => {
  try {
    const [companyAgg, userAgg] = await Promise.all([
      Company.aggregate([
        {
          $group: {
            _id: null,
            total: { $sum: 1 },
            active: { $sum: { $cond: ['$isActive', 1, 0] } },
          },
        },
      ]),
      User.aggregate([
        {
          $group: {
            _id: '$role',
            count: { $sum: 1 },
            active: { $sum: { $cond: ['$isActive', 1, 0] } },
          },
        },
      ]),
    ]);

    res.json({
      success: true,
      data: {
        companies: companyAgg[0] ?? { total: 0, active: 0 },
        usersByRole: userAgg,
      },
    });
  } catch (err) {
    next(err);
  }
};
