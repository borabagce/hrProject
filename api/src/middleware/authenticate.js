import { verifyAccessToken } from '../utils/jwt.js';
import { User } from '../models/User.js';
import { ApiError } from '../utils/ApiError.js';

export const authenticate = async (req, _res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) throw ApiError.unauthorized();

    const token = authHeader.slice(7);
    const payload = await verifyAccessToken(token);

    const user = await User.findById(payload.sub).select('+isActive');
    if (!user || !user.isActive) throw ApiError.unauthorized('Account not found or inactive');

    req.user = user;
    next();
  } catch (err) {
    if (err.isOperational) return next(err);
    next(ApiError.unauthorized('Invalid or expired token'));
  }
};
