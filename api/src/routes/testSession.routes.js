import { Router } from 'express';
import { body, param } from 'express-validator';
import {
  startSession,
  startReviewSession,
  getSessionQuestions,
  submitAnswer,
  getSessionResult,
  getMySessions,
  getCompanySessions,
} from '../controllers/testSession.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';
import { validate } from '../middleware/validate.js';

const router = Router();

router.use(authenticate);

router.get('/me', getMySessions);
router.get('/company', authorize('admin', 'hr'), getCompanySessions);

router.post(
  '/start',
  authorize('employee'),
  [
    body('questionCount').optional().isInt({ min: 5, max: 50 }),
    body('categoryId').optional().isMongoId(),
  ],
  validate,
  startSession
);

router.post(
  '/review/start',
  authorize('employee'),
  [body('questionCount').optional().isInt({ min: 1, max: 30 })],
  validate,
  startReviewSession
);

router.get(
  '/:id/questions',
  authorize('employee'),
  [param('id').isMongoId()],
  validate,
  getSessionQuestions
);

router.post(
  '/:id/answer',
  authorize('employee'),
  [
    param('id').isMongoId(),
    body('questionId').isMongoId(),
    body('selectedOptionOrder').isInt({ min: 0 }),
    body('responseTimeSec').optional().isFloat({ min: 0 }),
  ],
  validate,
  submitAnswer
);

router.get(
  '/:id/result',
  [param('id').isMongoId()],
  validate,
  getSessionResult
);

export default router;
