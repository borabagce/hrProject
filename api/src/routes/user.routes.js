import { Router } from 'express';
import { body, param } from 'express-validator';
import {
  getUsers,
  getUser,
  createUser,
  updateUser,
  updateMyProfile,
  changeMyPassword,
} from '../controllers/user.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';
import { validate } from '../middleware/validate.js';

const router = Router();

router.use(authenticate);

router.get('/me/profile', updateMyProfile);
router.put(
  '/me/profile',
  [body('fullName').trim().notEmpty().isLength({ max: 100 })],
  validate,
  updateMyProfile
);

router.put(
  '/me/password',
  [
    body('currentPassword').notEmpty(),
    body('newPassword').isLength({ min: 8, max: 72 }),
  ],
  validate,
  changeMyPassword
);

router.get('/', authorize('admin', 'hr'), getUsers);
router.get('/:id', authorize('admin', 'hr'), [param('id').isMongoId()], validate, getUser);

router.post(
  '/',
  authorize('admin', 'hr'),
  [
    body('fullName').trim().notEmpty().isLength({ max: 100 }),
    body('email').isEmail().normalizeEmail(),
    body('password').isLength({ min: 8, max: 72 }),
    body('role').optional().isIn(['admin', 'hr', 'manager', 'employee']),
    body('departmentId').optional().isMongoId(),
  ],
  validate,
  createUser
);

router.put(
  '/:id',
  authorize('admin', 'hr'),
  [
    param('id').isMongoId(),
    body('fullName').optional().trim().notEmpty().isLength({ max: 100 }),
    body('role').optional().isIn(['admin', 'hr', 'manager', 'employee']),
    body('departmentId').optional().isMongoId(),
    body('isActive').optional().isBoolean(),
  ],
  validate,
  updateUser
);

export default router;
