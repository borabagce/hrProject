import { Router } from 'express';
import { body, param } from 'express-validator';
import {
  getCategories,
  createCategory,
  updateCategory,
  deleteCategory,
} from '../controllers/category.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';
import { validate } from '../middleware/validate.js';

const router = Router();

router.use(authenticate);

router.get('/', getCategories);

router.post(
  '/',
  authorize('admin', 'hr'),
  [
    body('name').trim().notEmpty().isLength({ max: 100 }),
    body('description').optional().trim().isLength({ max: 500 }),
  ],
  validate,
  createCategory
);

router.put(
  '/:id',
  authorize('admin', 'hr'),
  [
    param('id').isMongoId(),
    body('name').optional().trim().notEmpty().isLength({ max: 100 }),
    body('description').optional().trim().isLength({ max: 500 }),
  ],
  validate,
  updateCategory
);

router.delete(
  '/:id',
  authorize('admin'),
  [param('id').isMongoId()],
  validate,
  deleteCategory
);

export default router;
