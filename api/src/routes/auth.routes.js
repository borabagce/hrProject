import { Router } from 'express';
import { body } from 'express-validator';
import { login, mobileLogin, refreshToken, getMe } from '../controllers/auth.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { validate } from '../middleware/validate.js';
import { authLimiter } from '../middleware/rateLimiter.js';

const router = Router();

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
  '/mobile/login',
  authLimiter,
  [
    body('email').isEmail().normalizeEmail(),
    body('password').notEmpty(),
  ],
  validate,
  mobileLogin
);

router.post(
  '/refresh',
  [body('refreshToken').notEmpty()],
  validate,
  refreshToken
);

router.get('/me', authenticate, getMe);

export default router;
