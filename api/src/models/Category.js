import mongoose from 'mongoose';

const categorySchema = new mongoose.Schema(
  {
    companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
    name: { type: String, required: true, trim: true, maxlength: 100 },
    description: { type: String, trim: true, maxlength: 500 },
  },
  { timestamps: true }
);

categorySchema.index({ companyId: 1 });
categorySchema.index({ companyId: 1, name: 1 }, { unique: true });

export const Category = mongoose.model('Category', categorySchema);
