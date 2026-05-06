import { Router } from 'express';
import { body, param } from 'express-validator';
import {
  getDepartments,
  getDepartment,
  createDepartment,
  updateDepartment,
  deleteDepartment,
} from '../controllers/department.controller.js';
import { authenticate } from '../middleware/authenticate.js';
import { authorize } from '../middleware/authorize.js';
import { validate } from '../middleware/validate.js';

const router = Router();

router.use(authenticate);

router.get('/', getDepartments);
router.get('/:id', [param('id').isMongoId()], validate, getDepartment);

router.post(
  '/',
  authorize('admin', 'hr'),
  [
    body('name').trim().notEmpty().isLength({ max: 100 }),
    body('managerId').optional().isMongoId(),
  ],
  validate,
  createDepartment
);

router.put(
  '/:id',
  authorize('admin', 'hr'),
  [
    param('id').isMongoId(),
    body('name').optional().trim().notEmpty().isLength({ max: 100 }),
    body('managerId').optional().isMongoId(),
  ],
  validate,
  updateDepartment
);

router.delete(
  '/:id',
  authorize('admin'),
  [param('id').isMongoId()],
  validate,
  deleteDepartment
);

export default router;
