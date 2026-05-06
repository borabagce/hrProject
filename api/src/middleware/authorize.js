import { ApiError } from '../utils/ApiError.js';

export const authorize = (...roles) =>
  (req, _res, next) => {
    if (!roles.includes(req.user.role)) {
      return next(ApiError.forbidden('Insufficient permissions'));
    }
    next();
  };

export const requireSameCompany = (req, _res, next) => {
  const companyId = req.params.companyId || req.body.companyId;
  if (companyId && companyId !== req.user.companyId.toString()) {
    return next(ApiError.forbidden());
  }
  next();
};
