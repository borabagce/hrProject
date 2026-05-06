import { Router } from 'express';
import { body, param } from 'express-validator';
import {
  getQuestions,
  getQuestion,
  createQuestion,
  updateQuestion,
  deleteQuestion,
} from '../controllers/question.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';
import { validate } from '../middleware/validate.js';

const router = Router();

router.use(authenticate);

const optionValidation = [
  body('options').isArray({ min: 2, max: 6 }),
  body('options.*.text').trim().notEmpty().isLength({ max: 500 }),
  body('options.*.isCorrect').isBoolean(),
  body('options.*.order').isInt({ min: 0 }),
];

router.get('/', getQuestions);
router.get('/:id', [param('id').isMongoId()], validate, getQuestion);

router.post(
  '/',
  authorize('admin', 'hr'),
  [
    body('categoryId').isMongoId(),
    body('text').trim().notEmpty(),
    body('type').isIn(['multiple_choice', 'true_false']),
    body('difficulty').isInt({ min: 1, max: 5 }),
    ...optionValidation,
  ],
  validate,
  createQuestion
);

router.put(
  '/:id',
  authorize('admin', 'hr'),
  [
    param('id').isMongoId(),
    body('text').optional().trim().notEmpty(),
    body('type').optional().isIn(['multiple_choice', 'true_false']),
    body('difficulty').optional().isInt({ min: 1, max: 5 }),
    body('isActive').optional().isBoolean(),
    body('categoryId').optional().isMongoId(),
  ],
  validate,
  updateQuestion
);

router.delete(
  '/:id',
  authorize('admin', 'hr'),
  [param('id').isMongoId()],
  validate,
  deleteQuestion
);

export default router;
