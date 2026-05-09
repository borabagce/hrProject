import { Router } from 'express';
import { param, query } from 'express-validator';
import {
  getMyAssignments,
  getAssignments,
  startAssignment,
  completeAssignment,
} from '../controllers/assignment.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';
import { validate } from '../middleware/validate.js';

const router = Router();

router.use(authenticate);

router.get(
  '/me',
  [query('status').optional().isIn(['pending', 'in_progress', 'completed', 'expired'])],
  validate,
  getMyAssignments
);

router.get(
  '/',
  authorize('admin', 'hr'),
  [
    query('testId').optional().isMongoId(),
    query('assignedTo').optional().isMongoId(),
    query('status').optional().isIn(['pending', 'in_progress', 'completed', 'expired']),
    query('page').optional().isInt({ min: 1 }),
    query('limit').optional().isInt({ min: 1, max: 100 }),
  ],
  validate,
  getAssignments
);

router.patch(
  '/:id/start',
  authorize('employee'),
  [param('id').isMongoId()],
  validate,
  startAssignment
);

router.patch(
  '/:id/complete',
  authorize('employee'),
  [param('id').isMongoId()],
  validate,
  completeAssignment
);

export default router;
