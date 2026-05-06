import 'dotenv/config';
import app from './app.js';
import { connectDB } from './config/database.js';
import { startWeeklyReportJob } from './jobs/weeklyReport.js';

const PORT = process.env.PORT || 5000;

connectDB()
  .then(() => {
    startWeeklyReportJob();
    app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
  })
  .catch((err) => {
    console.error('DB connection failed:', err);
    process.exit(1);
  });
