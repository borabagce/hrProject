import { ApiError } from '../utils/ApiError.js';

export const errorHandler = (err, _req, res, _next) => {
  if (err.isOperational) {
    return res.status(err.statusCode).json({
      success: false,
      message: err.message,
      ...(err.errors.length > 0 && { errors: err.errors }),
    });
  }

  if (err.name === 'ValidationError') {
    const errors = Object.values(err.errors).map((e) => ({
      field: e.path,
      message: e.message,
    }));
    return res.status(400).json({ success: false, message: 'Validation failed', errors });
  }

  if (err.code === 11000) {
    const field = Object.keys(err.keyPattern)[0];
    return res.status(409).json({ success: false, message: `${field} already exists` });
  }

  if (process.env.NODE_ENV === 'development') {
    console.error(err);
  }

  res.status(500).json({ success: false, message: 'Internal server error' });
};
