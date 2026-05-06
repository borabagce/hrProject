import mongoose from 'mongoose';

const testSessionSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
    weekNumber: { type: Number, required: true },
    year: { type: Number, required: true },
    questionIds: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Question' }],
    totalQuestions: { type: Number, required: true },
    correctCount: { type: Number, default: 0 },
    scorePercent: { type: Number, default: 0 },
    startedAt: { type: Date, default: Date.now },
    completedAt: { type: Date, default: null },
    isCompleted: { type: Boolean, default: false },
    sessionType: { type: String, enum: ['weekly', 'review'], default: 'weekly' },
  },
  { timestamps: true }
);

testSessionSchema.index({ userId: 1, year: 1, weekNumber: 1 });
testSessionSchema.index({ companyId: 1, year: 1, weekNumber: 1 });
testSessionSchema.index({ userId: 1, isCompleted: 1 });

testSessionSchema.statics.getWeekNumber = (date = new Date()) => {
  const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
  d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return {
    week: Math.ceil(((d - yearStart) / 86400000 + 1) / 7),
    year: d.getUTCFullYear(),
  };
};

export const TestSession = mongoose.model('TestSession', testSessionSchema);
