import { verifyAccessToken } from '../utils/jwt.js';
import { SystemAdmin } from '../models/SystemAdmin.js';
import { ApiError } from '../utils/ApiError.js';

export const authenticateSystemAdmin = async (req, _res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) throw ApiError.unauthorized();

    const token = authHeader.slice(7);
    const payload = await verifyAccessToken(token);

    if (payload.kind !== 'system') throw ApiError.forbidden('System admin access required');

    const admin = await SystemAdmin.findById(payload.sub);
    if (!admin || !admin.isActive) throw ApiError.unauthorized('Account not found or inactive');

    req.systemAdmin = admin;
    next();
  } catch (err) {
    if (err.isOperational) return next(err);
    next(ApiError.unauthorized('Invalid or expired token'));
  }
};
