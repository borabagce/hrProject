import mongoose from 'mongoose';

const departmentSchema = new mongoose.Schema(
  {
    companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
    name: { type: String, required: true, trim: true, maxlength: 100 },
    managerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null },
  },
  { timestamps: true }
);

departmentSchema.index({ companyId: 1 });
departmentSchema.index({ companyId: 1, name: 1 }, { unique: true });

export const Department = mongoose.model('Department', departmentSchema);
