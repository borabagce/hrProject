import mongoose from 'mongoose';

const hrReportSchema = new mongoose.Schema(
  {
    companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
    generatedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    reportType: {
      type: String,
      enum: ['weekly_summary', 'monthly_summary', 'risk_assessment'],
      required: true,
    },
    periodStart: { type: Date, required: true },
    periodEnd: { type: Date, required: true },
    avgScore: { type: Number, default: null },
    decayRate: { type: Number, default: null },
    riskLevel: { type: String, enum: ['low', 'medium', 'high'], default: null },
    reportData: { type: mongoose.Schema.Types.Mixed, default: {} },
  },
  { timestamps: true }
);

hrReportSchema.index({ companyId: 1, createdAt: -1 });
hrReportSchema.index({ companyId: 1, reportType: 1, periodStart: -1 });

export const HrReport = mongoose.model('HrReport', hrReportSchema);
