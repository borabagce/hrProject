import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics.freezed.dart';
part 'analytics.g.dart';

@freezed
class SessionHistoryItem with _$SessionHistoryItem {
  const factory SessionHistoryItem({
    @JsonKey(name: '_id') required String id,
    required int weekNumber,
    required int year,
    required int scorePercent,
    required int correctCount,
    required int totalQuestions,
    DateTime? completedAt,
  }) = _SessionHistoryItem;

  factory SessionHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$SessionHistoryItemFromJson(json);
}

@freezed
class CategoryBreakdown with _$CategoryBreakdown {
  const factory CategoryBreakdown({
    required String categoryName,
    required int total,
    required int wrong,
    required double errorRate,
  }) = _CategoryBreakdown;

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownFromJson(json);
}

@freezed
class WeeklyTrendPoint with _$WeeklyTrendPoint {
  const factory WeeklyTrendPoint({
    required String label,
    required int score,
  }) = _WeeklyTrendPoint;

  factory WeeklyTrendPoint.fromJson(Map<String, dynamic> json) =>
      _$WeeklyTrendPointFromJson(json);
}

@freezed
class MyAnalytics with _$MyAnalytics {
  const factory MyAnalytics({
    required List<SessionHistoryItem> sessionHistory,
    required List<CategoryBreakdown> wrongByCategory,
    required List<WeeklyTrendPoint> weeklyTrend,
  }) = _MyAnalytics;

  factory MyAnalytics.fromJson(Map<String, dynamic> json) =>
      _$MyAnalyticsFromJson(json);
}
