import mongoose from 'mongoose';

const userKnowledgeProfileSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    questionId: { type: mongoose.Schema.Types.ObjectId, ref: 'Question', required: true },
    companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
    repetitionCount: { type: Number, default: 0 },
    easinessFactor: { type: Number, default: 2.5 },
    intervalDays: { type: Number, default: 1 },
    nextReviewDate: { type: Date, default: Date.now },
    lastQuality: { type: Number, min: 0, max: 5, default: null },
    memoryStrength: { type: Number, min: 0, max: 1, default: 0 },
  },
  { timestamps: true }
);

userKnowledgeProfileSchema.index({ userId: 1, questionId: 1 }, { unique: true });
userKnowledgeProfileSchema.index({ userId: 1, nextReviewDate: 1 });
userKnowledgeProfileSchema.index({ companyId: 1, nextReviewDate: 1 });
userKnowledgeProfileSchema.index({ userId: 1, memoryStrength: 1 });

export const UserKnowledgeProfile = mongoose.model(
  'UserKnowledgeProfile',
  userKnowledgeProfileSchema
);
