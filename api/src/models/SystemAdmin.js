import mongoose from 'mongoose';
import argon2 from 'argon2';

const ARGON2_OPTIONS = {
  type: argon2.argon2id,
  memoryCost: 65536,
  timeCost: 3,
  parallelism: 4,
};

const systemAdminSchema = new mongoose.Schema(
  {
    fullName: { type: String, required: true, trim: true, maxlength: 100 },
    email: { type: String, required: true, lowercase: true, trim: true, maxlength: 150 },
    passwordHash: { type: String, required: true, select: false },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

systemAdminSchema.index({ email: 1 }, { unique: true });

systemAdminSchema.pre('save', async function (next) {
  if (!this.isModified('passwordHash')) return next();
  this.passwordHash = await argon2.hash(this.passwordHash, ARGON2_OPTIONS);
  next();
});

systemAdminSchema.methods.comparePassword = function (plain) {
  return argon2.verify(this.passwordHash, plain);
};

systemAdminSchema.set('toJSON', {
  transform: (_, ret) => {
    delete ret.passwordHash;
    return ret;
  },
});

export const SystemAdmin = mongoose.model('SystemAdmin', systemAdminSchema);
