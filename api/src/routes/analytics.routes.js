import { Router } from 'express';
import { body, param, query } from 'express-validator';
import {
  getCompanyOverview,
  getEmployeeAnalytics,
  getQuestionAnalytics,
  getDepartmentAnalytics,
  getMyAnalytics,
  generateReport,
  listReports,
  getReport,
} from '../controllers/analytics.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';
import { validate } from '../middleware/validate.js';

const router = Router();

router.use(authenticate);

router.get('/me', getMyAnalytics);

router.get('/overview', authorize('admin', 'hr'), getCompanyOverview);
router.get('/questions', authorize('admin', 'hr'), getQuestionAnalytics);
router.get('/departments', authorize('admin', 'hr'), getDepartmentAnalytics);
router.get(
  '/employees/:userId',
  authorize('admin', 'hr'),
  [param('userId').isMongoId()],
  validate,
  getEmployeeAnalytics
);

router.post(
  '/reports',
  authorize('admin', 'hr'),
  [
    body('reportType').isIn(['weekly_summary', 'monthly_summary', 'risk_assessment']),
    body('periodStart').isISO8601(),
    body('periodEnd').isISO8601(),
  ],
  validate,
  generateReport
);

router.get(
  '/reports',
  authorize('admin', 'hr'),
  [query('reportType').optional().isIn(['weekly_summary', 'monthly_summary', 'risk_assessment'])],
  validate,
  listReports
);

router.get(
  '/reports/:id',
  authorize('admin', 'hr'),
  [param('id').isMongoId()],
  validate,
  getReport
);

export default router;
