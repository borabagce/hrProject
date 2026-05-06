import mongoose from 'mongoose';

const optionSchema = new mongoose.Schema(
  {
    text: { type: String, required: true, trim: true, maxlength: 500 },
    isCorrect: { type: Boolean, required: true, default: false },
    order: { type: Number, required: true },
  },
  { _id: false }
);

const questionSchema = new mongoose.Schema(
  {
    companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
    categoryId: { type: mongoose.Schema.Types.ObjectId, ref: 'Category', required: true },
    createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    text: { type: String, required: true, trim: true },
    type: { type: String, enum: ['multiple_choice', 'true_false'], required: true },
    difficulty: { type: Number, min: 1, max: 5, required: true },
    options: {
      type: [optionSchema],
      validate: {
        validator: (opts) => opts.filter((o) => o.isCorrect).length === 1,
        message: 'Exactly one correct option is required',
      },
    },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

questionSchema.index({ companyId: 1, isActive: 1 });
questionSchema.index({ companyId: 1, categoryId: 1 });
questionSchema.index({ companyId: 1, difficulty: 1 });

export const Question = mongoose.model('Question', questionSchema);
