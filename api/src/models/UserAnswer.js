import mongoose from 'mongoose';

const userAnswerSchema = new mongoose.Schema(
  {
    sessionId: { type: mongoose.Schema.Types.ObjectId, ref: 'TestSession', required: true },
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
    questionId: { type: mongoose.Schema.Types.ObjectId, ref: 'Question', required: true },
    selectedOptionOrder: { type: Number, required: true },
    isCorrect: { type: Boolean, required: true },
    responseTimeSec: { type: Number, default: null },
    answeredAt: { type: Date, default: Date.now },
  },
  { timestamps: false }
);

userAnswerSchema.index({ sessionId: 1 });
userAnswerSchema.index({ userId: 1, questionId: 1 });
userAnswerSchema.index({ companyId: 1, questionId: 1, isCorrect: 1 });
userAnswerSchema.index({ sessionId: 1, questionId: 1 }, { unique: true });

export const UserAnswer = mongoose.model('UserAnswer', userAnswerSchema);
