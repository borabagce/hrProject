import mongoose from 'mongoose';

const testAssignmentSchema = new mongoose.Schema(
  {
    companyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Company', required: true },
    testId: { type: mongoose.Schema.Types.ObjectId, ref: 'Test', required: true },
    assignedTo: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    assignedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    dueDate: { type: Date, default: null },
    status: {
      type: String,
      enum: ['pending', 'in_progress', 'completed', 'expired'],
      default: 'pending',
    },
    sessionId: { type: mongoose.Schema.Types.ObjectId, ref: 'TestSession', default: null },
    completedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

testAssignmentSchema.index({ testId: 1, assignedTo: 1 }, { unique: true });
testAssignmentSchema.index({ companyId: 1, status: 1 });
testAssignmentSchema.index({ companyId: 1, assignedTo: 1 });
testAssignmentSchema.index({ companyId: 1, testId: 1 });

export const TestAssignment = mongoose.model('TestAssignment', testAssignmentSchema);
