import 'dotenv/config';
import mongoose from 'mongoose';
import { SystemAdmin } from '../src/models/SystemAdmin.js';

const { SYSADMIN_EMAIL, SYSADMIN_PASSWORD, SYSADMIN_NAME, MONGODB_URI } = process.env;

if (!MONGODB_URI) {
  console.error('MONGODB_URI is required');
  process.exit(1);
}
if (!SYSADMIN_EMAIL || !SYSADMIN_PASSWORD || !SYSADMIN_NAME) {
  console.error('SYSADMIN_EMAIL, SYSADMIN_PASSWORD and SYSADMIN_NAME env vars are required');
  process.exit(1);
}
if (SYSADMIN_PASSWORD.length < 12) {
  console.error('SYSADMIN_PASSWORD must be at least 12 characters');
  process.exit(1);
}

const run = async () => {
  await mongoose.connect(MONGODB_URI);

  const existing = await SystemAdmin.findOne({ email: SYSADMIN_EMAIL.toLowerCase() });
  if (existing) {
    console.log(`SystemAdmin already exists: ${existing.email}`);
    return;
  }

  const admin = await SystemAdmin.create({
    fullName: SYSADMIN_NAME,
    email: SYSADMIN_EMAIL,
    passwordHash: SYSADMIN_PASSWORD,
  });
  console.log(`SystemAdmin created: ${admin.email}`);
};

run()
  .catch((err) => {
    console.error(err);
    process.exitCode = 1;
  })
  .finally(() => mongoose.disconnect());
