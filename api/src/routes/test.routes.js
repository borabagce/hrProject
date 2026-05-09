import { Router } from 'express';
import { body, param, query } from 'express-validator';
import {
  getTests,
  getTest,
  createTest,
  updateTest,
  deleteTest,
  assignTest,
  getTestAssignments,
} from '../controllers/test.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';
import { validate } from '../middleware/validate.js';

const router = Router();

router.use(authenticate);

router.get(
  '/',
  [
    query('categoryId').optional().isMongoId(),
    query('isActive').optional().isBoolean(),
    query('page').optional().isInt({ min: 1 }),
    query('limit').optional().isInt({ min: 1, max: 100 }),
  ],
  validate,
  getTests
);

router.get('/:id', [param('id').isMongoId()], validate, getTest);

router.post(
  '/',
  authorize('admin', 'hr'),
  [
    body('title').trim().notEmpty().isLength({ max: 200 }),
    body('categoryId').optional().isMongoId(),
    body('type').isIn(['multiple_choice', 'true_false', 'mixed']),
    body('difficulty').isInt({ min: 1, max: 5 }),
    body('questionIds').optional().isArray(),
    body('questionIds.*').optional().isMongoId(),
    body('description').optional().trim().isLength({ max: 1000 }),
  ],
  validate,
  createTest
);

router.put(
  '/:id',
  authorize('admin', 'hr'),
  [
    param('id').isMongoId(),
    body('title').optional().trim().notEmpty().isLength({ max: 200 }),
    body('categoryId').optional().isMongoId(),
    body('type').optional().isIn(['multiple_choice', 'true_false', 'mixed']),
    body('difficulty').optional().isInt({ min: 1, max: 5 }),
    body('questionIds').optional().isArray(),
    body('questionIds.*').optional().isMongoId(),
    body('description').optional().trim().isLength({ max: 1000 }),
    body('isActive').optional().isBoolean(),
  ],
  validate,
  updateTest
);

router.delete(
  '/:id',
  authorize('admin', 'hr'),
  [param('id').isMongoId()],
  validate,
  deleteTest
);

router.post(
  '/:id/assign',
  authorize('admin', 'hr'),
  [
    param('id').isMongoId(),
    body('userIds').isArray({ min: 1 }),
    body('userIds.*').isMongoId(),
    body('dueDate').optional().isISO8601(),
  ],
  validate,
  assignTest
);

router.get(
  '/:id/assignments',
  authorize('admin', 'hr'),
  [param('id').isMongoId()],
  validate,
  getTestAssignments
);

export default router;
