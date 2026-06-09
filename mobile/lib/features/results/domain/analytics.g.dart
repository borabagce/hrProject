// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionHistoryItemImpl _$$SessionHistoryItemImplFromJson(
        Map<String, dynamic> json) =>
    _$SessionHistoryItemImpl(
      id: json['_id'] as String,
      weekNumber: (json['weekNumber'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      scorePercent: (json['scorePercent'] as num).toInt(),
      correctCount: (json['correctCount'] as num).toInt(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      testTitle: json['testTitle'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$SessionHistoryItemImplToJson(
        _$SessionHistoryItemImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'weekNumber': instance.weekNumber,
      'year': instance.year,
      'scorePercent': instance.scorePercent,
      'correctCount': instance.correctCount,
      'totalQuestions': instance.totalQuestions,
      'testTitle': instance.testTitle,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

_$CategoryBreakdownImpl _$$CategoryBreakdownImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryBreakdownImpl(
      categoryName: json['categoryName'] as String,
      total: (json['total'] as num).toInt(),
      wrong: (json['wrong'] as num).toInt(),
      errorRate: (json['errorRate'] as num).toDouble(),
    );

Map<String, dynamic> _$$CategoryBreakdownImplToJson(
        _$CategoryBreakdownImpl instance) =>
    <String, dynamic>{
      'categoryName': instance.categoryName,
      'total': instance.total,
      'wrong': instance.wrong,
      'errorRate': instance.errorRate,
    };

_$WeeklyTrendPointImpl _$$WeeklyTrendPointImplFromJson(
        Map<String, dynamic> json) =>
    _$WeeklyTrendPointImpl(
      label: json['label'] as String,
      score: (json['score'] as num).toInt(),
    );

Map<String, dynamic> _$$WeeklyTrendPointImplToJson(
        _$WeeklyTrendPointImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'score': instance.score,
    };

_$MyAnalyticsImpl _$$MyAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$MyAnalyticsImpl(
      sessionHistory: (json['sessionHistory'] as List<dynamic>)
          .map((e) => SessionHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      wrongByCategory: (json['wrongByCategory'] as List<dynamic>)
          .map((e) => CategoryBreakdown.fromJson(e as Map<String, dynamic>))
          .toList(),
      weeklyTrend: (json['weeklyTrend'] as List<dynamic>)
          .map((e) => WeeklyTrendPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MyAnalyticsImplToJson(_$MyAnalyticsImpl instance) =>
    <String, dynamic>{
      'sessionHistory': instance.sessionHistory,
      'wrongByCategory': instance.wrongByCategory,
      'weeklyTrend': instance.weeklyTrend,
    };
