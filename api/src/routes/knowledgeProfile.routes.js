import { Router } from 'express';
import { param, query } from 'express-validator';
import {
  getMyKnowledgeOverview,
  getMyDueQuestions,
  getCompanyKnowledgeStats,
  getEmployeeKnowledgeProfile,
} from '../controllers/knowledgeProfile.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';
import { validate } from '../middleware/validate.js';

const router = Router();

router.use(authenticate);

router.get('/me', getMyKnowledgeOverview);
router.get('/me/due', [query('limit').optional().isInt({ min: 1, max: 50 })], validate, getMyDueQuestions);

router.get('/company', authorize('admin', 'hr'), getCompanyKnowledgeStats);
router.get(
  '/employees/:userId',
  authorize('admin', 'hr'),
  [param('userId').isMongoId()],
  validate,
  getEmployeeKnowledgeProfile
);

export default router;
