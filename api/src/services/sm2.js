const INITIAL_EASINESS = 2.5;
const MIN_EASINESS = 1.3;
const MS_PER_DAY = 86400000;

export function deriveQuality(isCorrect, responseTimeSec, difficulty = 3) {
  if (!isCorrect) {
    if (difficulty >= 4) return 2;
    if (difficulty === 3) return 1;
    return 0;
  }

  let base;
  if (responseTimeSec == null) base = 4;
  else if (responseTimeSec <= 20) base = 5;
  else if (responseTimeSec <= 60) base = 4;
  else base = 3;

  if (difficulty >= 4 && base === 3) base = 4;

  return base;
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

export function effectiveMemoryStrength(profile, now = new Date()) {
  const base = profile.memoryStrength ?? 0;
  if (base === 0) return 0;
  const last = profile.updatedAt ?? profile.createdAt ?? now;
  const elapsedDays = Math.max(0, (now - new Date(last)) / MS_PER_DAY);
  const tau = Math.max(
    1,
    (profile.intervalDays ?? 1) * (profile.easinessFactor ?? INITIAL_EASINESS)
  );
  return parseFloat((base * Math.exp(-elapsedDays / tau)).toFixed(4));
}

export const effectiveMemoryStrengthExpr = {
  $multiply: [
    '$memoryStrength',
    {
      $exp: {
        $multiply: [
          -1,
          {
            $divide: [
              { $divide: [{ $subtract: ['$$NOW', '$updatedAt'] }, MS_PER_DAY] },
              { $max: [1, { $multiply: ['$intervalDays', '$easinessFactor'] }] },
            ],
          },
        ],
      },
    },
  ],
};
