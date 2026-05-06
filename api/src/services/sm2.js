const INITIAL_EASINESS = 2.5;
const MIN_EASINESS = 1.3;

export function deriveQuality(isCorrect, responseTimeSec) {
  if (!isCorrect) return 1;
  if (responseTimeSec == null) return 4;
  if (responseTimeSec > 60) return 3;
  if (responseTimeSec > 20) return 4;
  return 5;
}

export function computeSm2(profile, quality) {
  let { repetitionCount, easinessFactor, intervalDays } = profile;

  if (quality < 3) {
    repetitionCount = 0;
    intervalDays = 1;
  } else {
    easinessFactor = Math.max(
      MIN_EASINESS,
      easinessFactor + 0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)
    );

    if (repetitionCount === 0) intervalDays = 1;
    else if (repetitionCount === 1) intervalDays = 6;
    else intervalDays = Math.round(intervalDays * easinessFactor);

    repetitionCount += 1;
  }

  const nextReviewDate = new Date();
  nextReviewDate.setDate(nextReviewDate.getDate() + intervalDays);
  nextReviewDate.setHours(0, 0, 0, 0);

  return {
    repetitionCount,
    easinessFactor: parseFloat(easinessFactor.toFixed(2)),
    intervalDays,
    nextReviewDate,
    lastQuality: quality,
    memoryStrength: parseFloat(Math.min(1, intervalDays / 30).toFixed(4)),
  };
}

export function defaultProfile() {
  return {
    repetitionCount: 0,
    easinessFactor: INITIAL_EASINESS,
    intervalDays: 1,
  };
}
