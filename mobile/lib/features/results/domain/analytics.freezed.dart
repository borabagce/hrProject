// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SessionHistoryItem _$SessionHistoryItemFromJson(Map<String, dynamic> json) {
  return _SessionHistoryItem.fromJson(json);
}

/// @nodoc
mixin _$SessionHistoryItem {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  int get weekNumber => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  int get scorePercent => throw _privateConstructorUsedError;
  int get correctCount => throw _privateConstructorUsedError;
  int get totalQuestions => throw _privateConstructorUsedError;
  String? get testTitle => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this SessionHistoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionHistoryItemCopyWith<SessionHistoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionHistoryItemCopyWith<$Res> {
  factory $SessionHistoryItemCopyWith(
          SessionHistoryItem value, $Res Function(SessionHistoryItem) then) =
      _$SessionHistoryItemCopyWithImpl<$Res, SessionHistoryItem>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      int weekNumber,
      int year,
      int scorePercent,
      int correctCount,
      int totalQuestions,
      String? testTitle,
      DateTime? completedAt});
}

/// @nodoc
class _$SessionHistoryItemCopyWithImpl<$Res, $Val extends SessionHistoryItem>
    implements $SessionHistoryItemCopyWith<$Res> {
  _$SessionHistoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weekNumber = null,
    Object? year = null,
    Object? scorePercent = null,
    Object? correctCount = null,
    Object? totalQuestions = null,
    Object? testTitle = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      scorePercent: null == scorePercent
          ? _value.scorePercent
          : scorePercent // ignore: cast_nullable_to_non_nullable
              as int,
      correctCount: null == correctCount
          ? _value.correctCount
          : correctCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      testTitle: freezed == testTitle
          ? _value.testTitle
          : testTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionHistoryItemImplCopyWith<$Res>
    implements $SessionHistoryItemCopyWith<$Res> {
  factory _$$SessionHistoryItemImplCopyWith(_$SessionHistoryItemImpl value,
          $Res Function(_$SessionHistoryItemImpl) then) =
      __$$SessionHistoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      int weekNumber,
      int year,
      int scorePercent,
      int correctCount,
      int totalQuestions,
      String? testTitle,
      DateTime? completedAt});
}

/// @nodoc
class __$$SessionHistoryItemImplCopyWithImpl<$Res>
    extends _$SessionHistoryItemCopyWithImpl<$Res, _$SessionHistoryItemImpl>
    implements _$$SessionHistoryItemImplCopyWith<$Res> {
  __$$SessionHistoryItemImplCopyWithImpl(_$SessionHistoryItemImpl _value,
      $Res Function(_$SessionHistoryItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weekNumber = null,
    Object? year = null,
    Object? scorePercent = null,
    Object? correctCount = null,
    Object? totalQuestions = null,
    Object? testTitle = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$SessionHistoryItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      scorePercent: null == scorePercent
          ? _value.scorePercent
          : scorePercent // ignore: cast_nullable_to_non_nullable
              as int,
      correctCount: null == correctCount
          ? _value.correctCount
          : correctCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      testTitle: freezed == testTitle
          ? _value.testTitle
          : testTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionHistoryItemImpl implements _SessionHistoryItem {
  const _$SessionHistoryItemImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.weekNumber,
      required this.year,
      required this.scorePercent,
      required this.correctCount,
      required this.totalQuestions,
      this.testTitle,
      this.completedAt});

  factory _$SessionHistoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionHistoryItemImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final int weekNumber;
  @override
  final int year;
  @override
  final int scorePercent;
  @override
  final int correctCount;
  @override
  final int totalQuestions;
  @override
  final String? testTitle;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'SessionHistoryItem(id: $id, weekNumber: $weekNumber, year: $year, scorePercent: $scorePercent, correctCount: $correctCount, totalQuestions: $totalQuestions, testTitle: $testTitle, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionHistoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.scorePercent, scorePercent) ||
                other.scorePercent == scorePercent) &&
            (identical(other.correctCount, correctCount) ||
                other.correctCount == correctCount) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.testTitle, testTitle) ||
                other.testTitle == testTitle) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, weekNumber, year,
      scorePercent, correctCount, totalQuestions, testTitle, completedAt);

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionHistoryItemImplCopyWith<_$SessionHistoryItemImpl> get copyWith =>
      __$$SessionHistoryItemImplCopyWithImpl<_$SessionHistoryItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionHistoryItemImplToJson(
      this,
    );
  }
}

abstract class _SessionHistoryItem implements SessionHistoryItem {
  const factory _SessionHistoryItem(
      {@JsonKey(name: '_id') required final String id,
      required final int weekNumber,
      required final int year,
      required final int scorePercent,
      required final int correctCount,
      required final int totalQuestions,
      final String? testTitle,
      final DateTime? completedAt}) = _$SessionHistoryItemImpl;

  factory _SessionHistoryItem.fromJson(Map<String, dynamic> json) =
      _$SessionHistoryItemImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  int get weekNumber;
  @override
  int get year;
  @override
  int get scorePercent;
  @override
  int get correctCount;
  @override
  int get totalQuestions;
  @override
  String? get testTitle;
  @override
  DateTime? get completedAt;

  /// Create a copy of SessionHistoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionHistoryItemImplCopyWith<_$SessionHistoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryBreakdown _$CategoryBreakdownFromJson(Map<String, dynamic> json) {
  return _CategoryBreakdown.fromJson(json);
}

/// @nodoc
mixin _$CategoryBreakdown {
  String get categoryName => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get wrong => throw _privateConstructorUsedError;
  double get errorRate => throw _privateConstructorUsedError;

  /// Serializes this CategoryBreakdown to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryBreakdownCopyWith<CategoryBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryBreakdownCopyWith<$Res> {
  factory $CategoryBreakdownCopyWith(
          CategoryBreakdown value, $Res Function(CategoryBreakdown) then) =
      _$CategoryBreakdownCopyWithImpl<$Res, CategoryBreakdown>;
  @useResult
  $Res call({String categoryName, int total, int wrong, double errorRate});
}

/// @nodoc
class _$CategoryBreakdownCopyWithImpl<$Res, $Val extends CategoryBreakdown>
    implements $CategoryBreakdownCopyWith<$Res> {
  _$CategoryBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryName = null,
    Object? total = null,
    Object? wrong = null,
    Object? errorRate = null,
  }) {
    return _then(_value.copyWith(
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      wrong: null == wrong
          ? _value.wrong
          : wrong // ignore: cast_nullable_to_non_nullable
              as int,
      errorRate: null == errorRate
          ? _value.errorRate
          : errorRate // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryBreakdownImplCopyWith<$Res>
    implements $CategoryBreakdownCopyWith<$Res> {
  factory _$$CategoryBreakdownImplCopyWith(_$CategoryBreakdownImpl value,
          $Res Function(_$CategoryBreakdownImpl) then) =
      __$$CategoryBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String categoryName, int total, int wrong, double errorRate});
}

/// @nodoc
class __$$CategoryBreakdownImplCopyWithImpl<$Res>
    extends _$CategoryBreakdownCopyWithImpl<$Res, _$CategoryBreakdownImpl>
    implements _$$CategoryBreakdownImplCopyWith<$Res> {
  __$$CategoryBreakdownImplCopyWithImpl(_$CategoryBreakdownImpl _value,
      $Res Function(_$CategoryBreakdownImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryName = null,
    Object? total = null,
    Object? wrong = null,
    Object? errorRate = null,
  }) {
    return _then(_$CategoryBreakdownImpl(
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      wrong: null == wrong
          ? _value.wrong
          : wrong // ignore: cast_nullable_to_non_nullable
              as int,
      errorRate: null == errorRate
          ? _value.errorRate
          : errorRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryBreakdownImpl implements _CategoryBreakdown {
  const _$CategoryBreakdownImpl(
      {required this.categoryName,
      required this.total,
      required this.wrong,
      required this.errorRate});

  factory _$CategoryBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryBreakdownImplFromJson(json);

  @override
  final String categoryName;
  @override
  final int total;
  @override
  final int wrong;
  @override
  final double errorRate;

  @override
  String toString() {
    return 'CategoryBreakdown(categoryName: $categoryName, total: $total, wrong: $wrong, errorRate: $errorRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryBreakdownImpl &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.wrong, wrong) || other.wrong == wrong) &&
            (identical(other.errorRate, errorRate) ||
                other.errorRate == errorRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, categoryName, total, wrong, errorRate);

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryBreakdownImplCopyWith<_$CategoryBreakdownImpl> get copyWith =>
      __$$CategoryBreakdownImplCopyWithImpl<_$CategoryBreakdownImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryBreakdownImplToJson(
      this,
    );
  }
}

abstract class _CategoryBreakdown implements CategoryBreakdown {
  const factory _CategoryBreakdown(
      {required final String categoryName,
      required final int total,
      required final int wrong,
      required final double errorRate}) = _$CategoryBreakdownImpl;

  factory _CategoryBreakdown.fromJson(Map<String, dynamic> json) =
      _$CategoryBreakdownImpl.fromJson;

  @override
  String get categoryName;
  @override
  int get total;
  @override
  int get wrong;
  @override
  double get errorRate;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryBreakdownImplCopyWith<_$CategoryBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklyTrendPoint _$WeeklyTrendPointFromJson(Map<String, dynamic> json) {
  return _WeeklyTrendPoint.fromJson(json);
}

/// @nodoc
mixin _$WeeklyTrendPoint {
  String get label => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;

  /// Serializes this WeeklyTrendPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyTrendPointCopyWith<WeeklyTrendPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyTrendPointCopyWith<$Res> {
  factory $WeeklyTrendPointCopyWith(
          WeeklyTrendPoint value, $Res Function(WeeklyTrendPoint) then) =
      _$WeeklyTrendPointCopyWithImpl<$Res, WeeklyTrendPoint>;
  @useResult
  $Res call({String label, int score});
}

/// @nodoc
class _$WeeklyTrendPointCopyWithImpl<$Res, $Val extends WeeklyTrendPoint>
    implements $WeeklyTrendPointCopyWith<$Res> {
  _$WeeklyTrendPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? score = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyTrendPointImplCopyWith<$Res>
    implements $WeeklyTrendPointCopyWith<$Res> {
  factory _$$WeeklyTrendPointImplCopyWith(_$WeeklyTrendPointImpl value,
          $Res Function(_$WeeklyTrendPointImpl) then) =
      __$$WeeklyTrendPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, int score});
}

/// @nodoc
class __$$WeeklyTrendPointImplCopyWithImpl<$Res>
    extends _$WeeklyTrendPointCopyWithImpl<$Res, _$WeeklyTrendPointImpl>
    implements _$$WeeklyTrendPointImplCopyWith<$Res> {
  __$$WeeklyTrendPointImplCopyWithImpl(_$WeeklyTrendPointImpl _value,
      $Res Function(_$WeeklyTrendPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeeklyTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? score = null,
  }) {
    return _then(_$WeeklyTrendPointImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyTrendPointImpl implements _WeeklyTrendPoint {
  const _$WeeklyTrendPointImpl({required this.label, required this.score});

  factory _$WeeklyTrendPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyTrendPointImplFromJson(json);

  @override
  final String label;
  @override
  final int score;

  @override
  String toString() {
    return 'WeeklyTrendPoint(label: $label, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyTrendPointImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, score);

  /// Create a copy of WeeklyTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyTrendPointImplCopyWith<_$WeeklyTrendPointImpl> get copyWith =>
      __$$WeeklyTrendPointImplCopyWithImpl<_$WeeklyTrendPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyTrendPointImplToJson(
      this,
    );
  }
}

abstract class _WeeklyTrendPoint implements WeeklyTrendPoint {
  const factory _WeeklyTrendPoint(
      {required final String label,
      required final int score}) = _$WeeklyTrendPointImpl;

  factory _WeeklyTrendPoint.fromJson(Map<String, dynamic> json) =
      _$WeeklyTrendPointImpl.fromJson;

  @override
  String get label;
  @override
  int get score;

  /// Create a copy of WeeklyTrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyTrendPointImplCopyWith<_$WeeklyTrendPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MyAnalytics _$MyAnalyticsFromJson(Map<String, dynamic> json) {
  return _MyAnalytics.fromJson(json);
}

/// @nodoc
mixin _$MyAnalytics {
  List<SessionHistoryItem> get sessionHistory =>
      throw _privateConstructorUsedError;
  List<CategoryBreakdown> get wrongByCategory =>
      throw _privateConstructorUsedError;
  List<WeeklyTrendPoint> get weeklyTrend => throw _privateConstructorUsedError;

  /// Serializes this MyAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MyAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyAnalyticsCopyWith<MyAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyAnalyticsCopyWith<$Res> {
  factory $MyAnalyticsCopyWith(
          MyAnalytics value, $Res Function(MyAnalytics) then) =
      _$MyAnalyticsCopyWithImpl<$Res, MyAnalytics>;
  @useResult
  $Res call(
      {List<SessionHistoryItem> sessionHistory,
      List<CategoryBreakdown> wrongByCategory,
      List<WeeklyTrendPoint> weeklyTrend});
}

/// @nodoc
class _$MyAnalyticsCopyWithImpl<$Res, $Val extends MyAnalytics>
    implements $MyAnalyticsCopyWith<$Res> {
  _$MyAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionHistory = null,
    Object? wrongByCategory = null,
    Object? weeklyTrend = null,
  }) {
    return _then(_value.copyWith(
      sessionHistory: null == sessionHistory
          ? _value.sessionHistory
          : sessionHistory // ignore: cast_nullable_to_non_nullable
              as List<SessionHistoryItem>,
      wrongByCategory: null == wrongByCategory
          ? _value.wrongByCategory
          : wrongByCategory // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdown>,
      weeklyTrend: null == weeklyTrend
          ? _value.weeklyTrend
          : weeklyTrend // ignore: cast_nullable_to_non_nullable
              as List<WeeklyTrendPoint>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyAnalyticsImplCopyWith<$Res>
    implements $MyAnalyticsCopyWith<$Res> {
  factory _$$MyAnalyticsImplCopyWith(
          _$MyAnalyticsImpl value, $Res Function(_$MyAnalyticsImpl) then) =
      __$$MyAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SessionHistoryItem> sessionHistory,
      List<CategoryBreakdown> wrongByCategory,
      List<WeeklyTrendPoint> weeklyTrend});
}

/// @nodoc
class __$$MyAnalyticsImplCopyWithImpl<$Res>
    extends _$MyAnalyticsCopyWithImpl<$Res, _$MyAnalyticsImpl>
    implements _$$MyAnalyticsImplCopyWith<$Res> {
  __$$MyAnalyticsImplCopyWithImpl(
      _$MyAnalyticsImpl _value, $Res Function(_$MyAnalyticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MyAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionHistory = null,
    Object? wrongByCategory = null,
    Object? weeklyTrend = null,
  }) {
    return _then(_$MyAnalyticsImpl(
      sessionHistory: null == sessionHistory
          ? _value._sessionHistory
          : sessionHistory // ignore: cast_nullable_to_non_nullable
              as List<SessionHistoryItem>,
      wrongByCategory: null == wrongByCategory
          ? _value._wrongByCategory
          : wrongByCategory // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdown>,
      weeklyTrend: null == weeklyTrend
          ? _value._weeklyTrend
          : weeklyTrend // ignore: cast_nullable_to_non_nullable
              as List<WeeklyTrendPoint>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MyAnalyticsImpl implements _MyAnalytics {
  const _$MyAnalyticsImpl(
      {required final List<SessionHistoryItem> sessionHistory,
      required final List<CategoryBreakdown> wrongByCategory,
      required final List<WeeklyTrendPoint> weeklyTrend})
      : _sessionHistory = sessionHistory,
        _wrongByCategory = wrongByCategory,
        _weeklyTrend = weeklyTrend;

  factory _$MyAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MyAnalyticsImplFromJson(json);

  final List<SessionHistoryItem> _sessionHistory;
  @override
  List<SessionHistoryItem> get sessionHistory {
    if (_sessionHistory is EqualUnmodifiableListView) return _sessionHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessionHistory);
  }

  final List<CategoryBreakdown> _wrongByCategory;
  @override
  List<CategoryBreakdown> get wrongByCategory {
    if (_wrongByCategory is EqualUnmodifiableListView) return _wrongByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wrongByCategory);
  }

  final List<WeeklyTrendPoint> _weeklyTrend;
  @override
  List<WeeklyTrendPoint> get weeklyTrend {
    if (_weeklyTrend is EqualUnmodifiableListView) return _weeklyTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyTrend);
  }

  @override
  String toString() {
    return 'MyAnalytics(sessionHistory: $sessionHistory, wrongByCategory: $wrongByCategory, weeklyTrend: $weeklyTrend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyAnalyticsImpl &&
            const DeepCollectionEquality()
                .equals(other._sessionHistory, _sessionHistory) &&
            const DeepCollectionEquality()
                .equals(other._wrongByCategory, _wrongByCategory) &&
            const DeepCollectionEquality()
                .equals(other._weeklyTrend, _weeklyTrend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_sessionHistory),
      const DeepCollectionEquality().hash(_wrongByCategory),
      const DeepCollectionEquality().hash(_weeklyTrend));

  /// Create a copy of MyAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyAnalyticsImplCopyWith<_$MyAnalyticsImpl> get copyWith =>
      __$$MyAnalyticsImplCopyWithImpl<_$MyAnalyticsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MyAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _MyAnalytics implements MyAnalytics {
  const factory _MyAnalytics(
      {required final List<SessionHistoryItem> sessionHistory,
      required final List<CategoryBreakdown> wrongByCategory,
      required final List<WeeklyTrendPoint> weeklyTrend}) = _$MyAnalyticsImpl;

  factory _MyAnalytics.fromJson(Map<String, dynamic> json) =
      _$MyAnalyticsImpl.fromJson;

  @override
  List<SessionHistoryItem> get sessionHistory;
  @override
  List<CategoryBreakdown> get wrongByCategory;
  @override
  List<WeeklyTrendPoint> get weeklyTrend;

  /// Create a copy of MyAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyAnalyticsImplCopyWith<_$MyAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
