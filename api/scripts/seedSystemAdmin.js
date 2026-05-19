import 'dotenv/config';
import mongoose from 'mongoose';
import { SystemAdmin } from '../src/models/SystemAdmin.js';

const { SYSADMIN_EMAIL, SYSADMIN_PASSWORD, SYSADMIN_NAME, MONGODB_URI } = process.env;

if (!SYSADMIN_EMAIL || !SYSADMIN_PASSWORD || !SYSADMIN_NAME) {
  console.log('[seedSystemAdmin] SYSADMIN_* env vars not set, skipping seed.');
  process.exit(0);
}
if (!MONGODB_URI) {
  console.error('[seedSystemAdmin] MONGODB_URI is required');
  process.exit(1);
}
if (SYSADMIN_PASSWORD.length < 12) {
  console.error('[seedSystemAdmin] SYSADMIN_PASSWORD must be at least 12 characters');
  process.exit(1);
}

const run = async () => {
  await mongoose.connect(MONGODB_URI);

  const existing = await SystemAdmin.findOne({ email: SYSADMIN_EMAIL.toLowerCase() });
  if (existing) {
    console.log(`[seedSystemAdmin] Already exists: ${existing.email}`);
    return;
  }

  const admin = await SystemAdmin.create({
    fullName: SYSADMIN_NAME,
    email: SYSADMIN_EMAIL,
    passwordHash: SYSADMIN_PASSWORD,
  });
  console.log(`[seedSystemAdmin] Created: ${admin.email}`);
};

run()
  .catch((err) => {
    console.error(err);
    process.exitCode = 1;
  })
  .finally(() => mongoose.disconnect());
