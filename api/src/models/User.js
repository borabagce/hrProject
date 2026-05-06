import mongoose from 'mongoose';
import argon2 from 'argon2';

const ARGON2_OPTIONS = {
  type: argon2.argon2id,
  memoryCost: 65536,
  timeCost: 3,
  parallelism: 4,
};

const userSchema = new mongoose.Schema(
  {
    companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
    departmentId: { type: mongoose.Schema.Types.ObjectId, ref: 'Department', default: null },
    fullName: { type: String, required: true, trim: true, maxlength: 100 },
    email: { type: String, required: true, lowercase: true, trim: true, maxlength: 150 },
    passwordHash: { type: String, required: true, select: false },
    role: { type: String, enum: ['admin', 'hr', 'employee'], default: 'employee' },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

userSchema.index({ email: 1 }, { unique: true });
userSchema.index({ companyId: 1, role: 1 });
userSchema.index({ companyId: 1, departmentId: 1 });

userSchema.pre('save', async function (next) {
  if (!this.isModified('passwordHash')) return next();
  this.passwordHash = await argon2.hash(this.passwordHash, ARGON2_OPTIONS);
  next();
});

userSchema.methods.comparePassword = function (plain) {
  return argon2.verify(this.passwordHash, plain);
};

userSchema.set('toJSON', {
  transform: (_, ret) => {
    delete ret.passwordHash;
    return ret;
  },
});

export const User = mongoose.model('User', userSchema);
