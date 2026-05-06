import { Company } from '../models/Company.js';
import { ApiError } from '../utils/ApiError.js';

export const getCompany = async (req, res, next) => {
  try {
    const company = await Company.findById(req.user.companyId);
    if (!company) throw ApiError.notFound('Company not found');
    res.json({ success: true, data: company });
  } catch (err) {
    next(err);
  }
};

export const updateCompany = async (req, res, next) => {
  try {
    const { name, industry, maxEmployees } = req.body;
    const company = await Company.findByIdAndUpdate(
      req.user.companyId,
      { name, industry, maxEmployees },
      { new: true, runValidators: true }
    );
    if (!company) throw ApiError.notFound('Company not found');
    res.json({ success: true, data: company });
  } catch (err) {
    next(err);
  }
};
