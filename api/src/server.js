import 'dotenv/config';
import app from './app.js';
import { connectDB, disconnectDB } from './config/database.js';
import { startWeeklyReportJob } from './jobs/weeklyReport.js';

const PORT = process.env.PORT || 5000;

connectDB()
  .then(() => {
    startWeeklyReportJob();
    const server = app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

    const shutdown = (signal) => {
      console.log(`${signal} received, shutting down gracefully`);
      server.close(async () => {
        await disconnectDB();
        process.exit(0);
      });
    };

    process.on('SIGTERM', () => shutdown('SIGTERM'));
    process.on('SIGINT', () => shutdown('SIGINT'));
  })
  .catch((err) => {
    console.error('DB connection failed:', err);
    process.exit(1);
  });
