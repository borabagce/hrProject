import mongoose from 'mongoose';

const testSchema = new mongoose.Schema(
  {
    companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
    createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    title: { type: String, required: true, trim: true, maxlength: 200 },
    categoryId: { type: mongoose.Schema.Types.ObjectId, ref: 'Category', default: null },
    type: { type: String, enum: ['multiple_choice', 'true_false', 'mixed'], required: true },
    difficulty: { type: Number, min: 1, max: 5, required: true },
    questionIds: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Question' }],
    description: { type: String, trim: true, maxlength: 1000, default: null },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

testSchema.index({ companyId: 1, isActive: 1 });
testSchema.index({ companyId: 1, categoryId: 1 });
testSchema.index({ companyId: 1, createdBy: 1 });

export const Test = mongoose.model('Test', testSchema);
