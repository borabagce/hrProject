import { Router } from 'express';
import { body } from 'express-validator';
import { getCompany, updateCompany } from '../controllers/company.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';
import { validate } from '../middleware/validate.js';

const router = Router();

router.use(authenticate);

router.get('/', getCompany);
router.put(
  '/',
  authorize('admin'),
  [
    body('name').optional().trim().notEmpty().isLength({ max: 150 }),
    body('industry').optional().trim().isLength({ max: 100 }),
    body('maxEmployees').optional().isInt({ min: 1 }),
  ],
  validate,
  updateCompany
);

export default router;
