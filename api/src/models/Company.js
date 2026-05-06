import mongoose from 'mongoose';

const companySchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true, maxlength: 150 },
    industry: { type: String, trim: true, maxlength: 100 },
    subscriptionPlan: {
      type: String,
      enum: ['basic', 'professional', 'enterprise'],
      default: 'basic',
    },
    maxEmployees: { type: Number, default: 50 },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

companySchema.index({ isActive: 1 });

export const Company = mongoose.model('Company', companySchema);
