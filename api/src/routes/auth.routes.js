import { Router } from 'express';
import { body } from 'express-validator';
import { register, login, refreshToken, getMe } from '../controllers/auth.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { validate } from '../middleware/validate.js';
import { authLimiter } from '../middleware/rateLimiter.js';

const router = Router();

router.post(
  '/register',
  authLimiter,
  [
    body('companyName').trim().notEmpty().isLength({ max: 150 }),
    body('fullName').trim().notEmpty().isLength({ max: 100 }),
    body('email').isEmail().normalizeEmail(),
    body('password').isLength({ min: 8, max: 72 }),
  ],
  validate,
  register
);

router.post(
  '/login',
  authLimiter,
  [
    body('email').isEmail().normalizeEmail(),
    body('password').notEmpty(),
  ],
  validate,
  login
);

router.post(
  '/refresh',
  [body('refreshToken').notEmpty()],
  validate,
  refreshToken
);

router.get('/me', authenticate, getMe);

export default router;
