import { Router } from 'express';
import { body, param } from 'express-validator';
import {
  login,
  refreshToken,
  getMe,
  listCompanies,
  getCompany,
  createCompany,
  updateCompany,
  getStats,
} from '../controllers/systemAdmin.controller.js';
import { authenticateSystemAdmin } from '../middleware/authenticateSystemAdmin.js';
import { validate } from '../middleware/validate.js';
import { authLimiter } from '../middleware/rateLimiter.js';

const router = Router();

router.post(
  '/auth/login',
  authLimiter,
  [
    body('email').isEmail().normalizeEmail(),
    body('password').notEmpty(),
  ],
  validate,
  login
);

router.post(
  '/auth/refresh',
  [body('refreshToken').notEmpty()],
  validate,
  refreshToken
);

router.use(authenticateSystemAdmin);

router.get('/auth/me', getMe);
router.get('/stats', getStats);

router.get('/companies', listCompanies);

router.get(
  '/companies/:id',
  [param('id').isMongoId()],
  validate,
  getCompany
);

router.post(
  '/companies',
  [
    body('name').trim().notEmpty().isLength({ max: 150 }),
    body('industry').optional().trim().isLength({ max: 100 }),
    body('subscriptionPlan').optional().isIn(['basic', 'professional', 'enterprise']),
    body('maxEmployees').optional().isInt({ min: 1 }),
    body('adminFullName').trim().notEmpty().isLength({ max: 100 }),
    body('adminEmail').isEmail().normalizeEmail(),
    body('adminPassword').isLength({ min: 8, max: 72 }),
    body('adminRole').isIn(['admin', 'hr']),
  ],
  validate,
  createCompany
);

router.patch(
  '/companies/:id',
  [
    param('id').isMongoId(),
    body('name').optional().trim().notEmpty().isLength({ max: 150 }),
    body('industry').optional().trim().isLength({ max: 100 }),
    body('subscriptionPlan').optional().isIn(['basic', 'professional', 'enterprise']),
    body('maxEmployees').optional().isInt({ min: 1 }),
    body('isActive').optional().isBoolean(),
  ],
  validate,
  updateCompany
);

export default router;
