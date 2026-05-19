import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { globalLimiter } from './middleware/rateLimiter.js';
import { errorHandler } from './middleware/errorHandler.js';
import authRoutes from './routes/auth.routes.js';
import companyRoutes from './routes/company.routes.js';
import departmentRoutes from './routes/department.routes.js';
import userRoutes from './routes/user.routes.js';
import categoryRoutes from './routes/category.routes.js';
import questionRoutes from './routes/question.routes.js';
import testSessionRoutes from './routes/testSession.routes.js';
import analyticsRoutes from './routes/analytics.routes.js';
import knowledgeProfileRoutes from './routes/knowledgeProfile.routes.js';
import testRoutes from './routes/test.routes.js';
import assignmentRoutes from './routes/assignment.routes.js';
import systemAdminRoutes from './routes/systemAdmin.routes.js';

const app = express();

app.use(helmet());
const allowedOrigins = process.env.CORS_ORIGIN?.split(',').map((s) => s.trim()).filter(Boolean) ?? [];
app.use(
  cors({
    origin: allowedOrigins,
    credentials: true,
  })
);
app.use(express.json({ limit: '10kb' }));
app.use(morgan(process.env.NODE_ENV === 'development' ? 'dev' : 'combined'));
app.use(globalLimiter);

app.use('/api/auth', authRoutes);
app.use('/api/company', companyRoutes);
app.use('/api/departments', departmentRoutes);
app.use('/api/users', userRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/questions', questionRoutes);
app.use('/api/sessions', testSessionRoutes);
app.use('/api/analytics', analyticsRoutes);
app.use('/api/knowledge', knowledgeProfileRoutes);
app.use('/api/tests', testRoutes);
app.use('/api/assignments', assignmentRoutes);
app.use('/api/sysadmin', systemAdminRoutes);

app.use((_req, res) => res.status(404).json({ success: false, message: 'Route not found' }));
app.use(errorHandler);

export default app;
