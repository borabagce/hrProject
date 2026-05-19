// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TestSession _$TestSessionFromJson(Map<String, dynamic> json) {
  return _TestSession.fromJson(json);
}

/// @nodoc
mixin _$TestSession {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  int get weekNumber => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  List<String> get questionIds => throw _privateConstructorUsedError;
  int get totalQuestions => throw _privateConstructorUsedError;
  int get correctCount => throw _privateConstructorUsedError;
  int get scorePercent => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  String get sessionType => throw _privateConstructorUsedError;

  /// Serializes this TestSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TestSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestSessionCopyWith<TestSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestSessionCopyWith<$Res> {
  factory $TestSessionCopyWith(
          TestSession value, $Res Function(TestSession) then) =
      _$TestSessionCopyWithImpl<$Res, TestSession>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String userId,
      String companyId,
      int weekNumber,
      int year,
      List<String> questionIds,
      int totalQuestions,
      int correctCount,
      int scorePercent,
      DateTime? startedAt,
      DateTime? completedAt,
      bool isCompleted,
      String sessionType});
}

/// @nodoc
class _$TestSessionCopyWithImpl<$Res, $Val extends TestSession>
    implements $TestSessionCopyWith<$Res> {
  _$TestSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? companyId = null,
    Object? weekNumber = null,
    Object? year = null,
    Object? questionIds = null,
    Object? totalQuestions = null,
    Object? correctCount = null,
    Object? scorePercent = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? isCompleted = null,
    Object? sessionType = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      questionIds: null == questionIds
          ? _value.questionIds
          : questionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctCount: null == correctCount
          ? _value.correctCount
          : correctCount // ignore: cast_nullable_to_non_nullable
              as int,
      scorePercent: null == scorePercent
          ? _value.scorePercent
          : scorePercent // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestSessionImplCopyWith<$Res>
    implements $TestSessionCopyWith<$Res> {
  factory _$$TestSessionImplCopyWith(
          _$TestSessionImpl value, $Res Function(_$TestSessionImpl) then) =
      __$$TestSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String userId,
      String companyId,
      int weekNumber,
      int year,
      List<String> questionIds,
      int totalQuestions,
      int correctCount,
      int scorePercent,
      DateTime? startedAt,
      DateTime? completedAt,
      bool isCompleted,
      String sessionType});
}

/// @nodoc
class __$$TestSessionImplCopyWithImpl<$Res>
    extends _$TestSessionCopyWithImpl<$Res, _$TestSessionImpl>
    implements _$$TestSessionImplCopyWith<$Res> {
  __$$TestSessionImplCopyWithImpl(
      _$TestSessionImpl _value, $Res Function(_$TestSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TestSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? companyId = null,
    Object? weekNumber = null,
    Object? year = null,
    Object? questionIds = null,
    Object? totalQuestions = null,
    Object? correctCount = null,
    Object? scorePercent = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? isCompleted = null,
    Object? sessionType = null,
  }) {
    return _then(_$TestSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      questionIds: null == questionIds
          ? _value._questionIds
          : questionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctCount: null == correctCount
          ? _value.correctCount
          : correctCount // ignore: cast_nullable_to_non_nullable
              as int,
      scorePercent: null == scorePercent
          ? _value.scorePercent
          : scorePercent // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionType: null == sessionType
          ? _value.sessionType
          : sessionType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestSessionImpl implements _TestSession {
  const _$TestSessionImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.userId,
      required this.companyId,
      required this.weekNumber,
      required this.year,
      required final List<String> questionIds,
      required this.totalQuestions,
      this.correctCount = 0,
      this.scorePercent = 0,
      this.startedAt,
      this.completedAt,
      this.isCompleted = false,
      this.sessionType = 'weekly'})
      : _questionIds = questionIds;

  factory _$TestSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestSessionImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String userId;
  @override
  final String companyId;
  @override
  final int weekNumber;
  @override
  final int year;
  final List<String> _questionIds;
  @override
  List<String> get questionIds {
    if (_questionIds is EqualUnmodifiableListView) return _questionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questionIds);
  }

  @override
  final int totalQuestions;
  @override
  @JsonKey()
  final int correctCount;
  @override
  @JsonKey()
  final int scorePercent;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final String sessionType;

  @override
  String toString() {
    return 'TestSession(id: $id, userId: $userId, companyId: $companyId, weekNumber: $weekNumber, year: $year, questionIds: $questionIds, totalQuestions: $totalQuestions, correctCount: $correctCount, scorePercent: $scorePercent, startedAt: $startedAt, completedAt: $completedAt, isCompleted: $isCompleted, sessionType: $sessionType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.year, year) || other.year == year) &&
            const DeepCollectionEquality()
                .equals(other._questionIds, _questionIds) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctCount, correctCount) ||
                other.correctCount == correctCount) &&
            (identical(other.scorePercent, scorePercent) ||
                other.scorePercent == scorePercent) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      companyId,
      weekNumber,
      year,
      const DeepCollectionEquality().hash(_questionIds),
      totalQuestions,
      correctCount,
      scorePercent,
      startedAt,
      completedAt,
      isCompleted,
      sessionType);

  /// Create a copy of TestSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestSessionImplCopyWith<_$TestSessionImpl> get copyWith =>
      __$$TestSessionImplCopyWithImpl<_$TestSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestSessionImplToJson(
      this,
    );
  }
}

abstract class _TestSession implements TestSession {
  const factory _TestSession(
      {@JsonKey(name: '_id') required final String id,
      required final String userId,
      required final String companyId,
      required final int weekNumber,
      required final int year,
      required final List<String> questionIds,
      required final int totalQuestions,
      final int correctCount,
      final int scorePercent,
      final DateTime? startedAt,
      final DateTime? completedAt,
      final bool isCompleted,
      final String sessionType}) = _$TestSessionImpl;

  factory _TestSession.fromJson(Map<String, dynamic> json) =
      _$TestSessionImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get userId;
  @override
  String get companyId;
  @override
  int get weekNumber;
  @override
  int get year;
  @override
  List<String> get questionIds;
  @override
  int get totalQuestions;
  @override
  int get correctCount;
  @override
  int get scorePercent;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  bool get isCompleted;
  @override
  String get sessionType;

  /// Create a copy of TestSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestSessionImplCopyWith<_$TestSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionQuestionsPayload _$SessionQuestionsPayloadFromJson(
    Map<String, dynamic> json) {
  return _SessionQuestionsPayload.fromJson(json);
}

/// @nodoc
mixin _$SessionQuestionsPayload {
  TestSession get session => throw _privateConstructorUsedError;
  List<ExamQuestion> get questions => throw _privateConstructorUsedError;

  /// Serializes this SessionQuestionsPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionQuestionsPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionQuestionsPayloadCopyWith<SessionQuestionsPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionQuestionsPayloadCopyWith<$Res> {
  factory $SessionQuestionsPayloadCopyWith(SessionQuestionsPayload value,
          $Res Function(SessionQuestionsPayload) then) =
      _$SessionQuestionsPayloadCopyWithImpl<$Res, SessionQuestionsPayload>;
  @useResult
  $Res call({TestSession session, List<ExamQuestion> questions});

  $TestSessionCopyWith<$Res> get session;
}

/// @nodoc
class _$SessionQuestionsPayloadCopyWithImpl<$Res,
        $Val extends SessionQuestionsPayload>
    implements $SessionQuestionsPayloadCopyWith<$Res> {
  _$SessionQuestionsPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionQuestionsPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? questions = null,
  }) {
    return _then(_value.copyWith(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as TestSession,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<ExamQuestion>,
    ) as $Val);
  }

  /// Create a copy of SessionQuestionsPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TestSessionCopyWith<$Res> get session {
    return $TestSessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionQuestionsPayloadImplCopyWith<$Res>
    implements $SessionQuestionsPayloadCopyWith<$Res> {
  factory _$$SessionQuestionsPayloadImplCopyWith(
          _$SessionQuestionsPayloadImpl value,
          $Res Function(_$SessionQuestionsPayloadImpl) then) =
      __$$SessionQuestionsPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TestSession session, List<ExamQuestion> questions});

  @override
  $TestSessionCopyWith<$Res> get session;
}

/// @nodoc
class __$$SessionQuestionsPayloadImplCopyWithImpl<$Res>
    extends _$SessionQuestionsPayloadCopyWithImpl<$Res,
        _$SessionQuestionsPayloadImpl>
    implements _$$SessionQuestionsPayloadImplCopyWith<$Res> {
  __$$SessionQuestionsPayloadImplCopyWithImpl(
      _$SessionQuestionsPayloadImpl _value,
      $Res Function(_$SessionQuestionsPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionQuestionsPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? questions = null,
  }) {
    return _then(_$SessionQuestionsPayloadImpl(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as TestSession,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<ExamQuestion>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionQuestionsPayloadImpl implements _SessionQuestionsPayload {
  const _$SessionQuestionsPayloadImpl(
      {required this.session, required final List<ExamQuestion> questions})
      : _questions = questions;

  factory _$SessionQuestionsPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionQuestionsPayloadImplFromJson(json);

  @override
  final TestSession session;
  final List<ExamQuestion> _questions;
  @override
  List<ExamQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'SessionQuestionsPayload(session: $session, questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionQuestionsPayloadImpl &&
            (identical(other.session, session) || other.session == session) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, session, const DeepCollectionEquality().hash(_questions));

  /// Create a copy of SessionQuestionsPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionQuestionsPayloadImplCopyWith<_$SessionQuestionsPayloadImpl>
      get copyWith => __$$SessionQuestionsPayloadImplCopyWithImpl<
          _$SessionQuestionsPayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionQuestionsPayloadImplToJson(
      this,
    );
  }
}

abstract class _SessionQuestionsPayload implements SessionQuestionsPayload {
  const factory _SessionQuestionsPayload(
          {required final TestSession session,
          required final List<ExamQuestion> questions}) =
      _$SessionQuestionsPayloadImpl;

  factory _SessionQuestionsPayload.fromJson(Map<String, dynamic> json) =
      _$SessionQuestionsPayloadImpl.fromJson;

  @override
  TestSession get session;
  @override
  List<ExamQuestion> get questions;

  /// Create a copy of SessionQuestionsPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionQuestionsPayloadImplCopyWith<_$SessionQuestionsPayloadImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AnswerRequest _$AnswerRequestFromJson(Map<String, dynamic> json) {
  return _AnswerRequest.fromJson(json);
}

/// @nodoc
mixin _$AnswerRequest {
  String get questionId => throw _privateConstructorUsedError;
  int get selectedOptionOrder => throw _privateConstructorUsedError;
  double? get responseTimeSec => throw _privateConstructorUsedError;

  /// Serializes this AnswerRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnswerRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnswerRequestCopyWith<AnswerRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerRequestCopyWith<$Res> {
  factory $AnswerRequestCopyWith(
          AnswerRequest value, $Res Function(AnswerRequest) then) =
      _$AnswerRequestCopyWithImpl<$Res, AnswerRequest>;
  @useResult
  $Res call(
      {String questionId, int selectedOptionOrder, double? responseTimeSec});
}

/// @nodoc
class _$AnswerRequestCopyWithImpl<$Res, $Val extends AnswerRequest>
    implements $AnswerRequestCopyWith<$Res> {
  _$AnswerRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnswerRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? selectedOptionOrder = null,
    Object? responseTimeSec = freezed,
  }) {
    return _then(_value.copyWith(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedOptionOrder: null == selectedOptionOrder
          ? _value.selectedOptionOrder
          : selectedOptionOrder // ignore: cast_nullable_to_non_nullable
              as int,
      responseTimeSec: freezed == responseTimeSec
          ? _value.responseTimeSec
          : responseTimeSec // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnswerRequestImplCopyWith<$Res>
    implements $AnswerRequestCopyWith<$Res> {
  factory _$$AnswerRequestImplCopyWith(
          _$AnswerRequestImpl value, $Res Function(_$AnswerRequestImpl) then) =
      __$$AnswerRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String questionId, int selectedOptionOrder, double? responseTimeSec});
}

/// @nodoc
class __$$AnswerRequestImplCopyWithImpl<$Res>
    extends _$AnswerRequestCopyWithImpl<$Res, _$AnswerRequestImpl>
    implements _$$AnswerRequestImplCopyWith<$Res> {
  __$$AnswerRequestImplCopyWithImpl(
      _$AnswerRequestImpl _value, $Res Function(_$AnswerRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnswerRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? selectedOptionOrder = null,
    Object? responseTimeSec = freezed,
  }) {
    return _then(_$AnswerRequestImpl(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedOptionOrder: null == selectedOptionOrder
          ? _value.selectedOptionOrder
          : selectedOptionOrder // ignore: cast_nullable_to_non_nullable
              as int,
      responseTimeSec: freezed == responseTimeSec
          ? _value.responseTimeSec
          : responseTimeSec // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnswerRequestImpl implements _AnswerRequest {
  const _$AnswerRequestImpl(
      {required this.questionId,
      required this.selectedOptionOrder,
      this.responseTimeSec});

  factory _$AnswerRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerRequestImplFromJson(json);

  @override
  final String questionId;
  @override
  final int selectedOptionOrder;
  @override
  final double? responseTimeSec;

  @override
  String toString() {
    return 'AnswerRequest(questionId: $questionId, selectedOptionOrder: $selectedOptionOrder, responseTimeSec: $responseTimeSec)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerRequestImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.selectedOptionOrder, selectedOptionOrder) ||
                other.selectedOptionOrder == selectedOptionOrder) &&
            (identical(other.responseTimeSec, responseTimeSec) ||
                other.responseTimeSec == responseTimeSec));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, questionId, selectedOptionOrder, responseTimeSec);

  /// Create a copy of AnswerRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerRequestImplCopyWith<_$AnswerRequestImpl> get copyWith =>
      __$$AnswerRequestImplCopyWithImpl<_$AnswerRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerRequestImplToJson(
      this,
    );
  }
}

abstract class _AnswerRequest implements AnswerRequest {
  const factory _AnswerRequest(
      {required final String questionId,
      required final int selectedOptionOrder,
      final double? responseTimeSec}) = _$AnswerRequestImpl;

  factory _AnswerRequest.fromJson(Map<String, dynamic> json) =
      _$AnswerRequestImpl.fromJson;

  @override
  String get questionId;
  @override
  int get selectedOptionOrder;
  @override
  double? get responseTimeSec;

  /// Create a copy of AnswerRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnswerRequestImplCopyWith<_$AnswerRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnswerResult _$AnswerResultFromJson(Map<String, dynamic> json) {
  return _AnswerResult.fromJson(json);
}

/// @nodoc
mixin _$AnswerResult {
  bool get isCorrect => throw _privateConstructorUsedError;
  int get correctOptionOrder => throw _privateConstructorUsedError;

  /// Serializes this AnswerResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnswerResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnswerResultCopyWith<AnswerResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerResultCopyWith<$Res> {
  factory $AnswerResultCopyWith(
          AnswerResult value, $Res Function(AnswerResult) then) =
      _$AnswerResultCopyWithImpl<$Res, AnswerResult>;
  @useResult
  $Res call({bool isCorrect, int correctOptionOrder});
}

/// @nodoc
class _$AnswerResultCopyWithImpl<$Res, $Val extends AnswerResult>
    implements $AnswerResultCopyWith<$Res> {
  _$AnswerResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnswerResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCorrect = null,
    Object? correctOptionOrder = null,
  }) {
    return _then(_value.copyWith(
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      correctOptionOrder: null == correctOptionOrder
          ? _value.correctOptionOrder
          : correctOptionOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnswerResultImplCopyWith<$Res>
    implements $AnswerResultCopyWith<$Res> {
  factory _$$AnswerResultImplCopyWith(
          _$AnswerResultImpl value, $Res Function(_$AnswerResultImpl) then) =
      __$$AnswerResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isCorrect, int correctOptionOrder});
}

/// @nodoc
class __$$AnswerResultImplCopyWithImpl<$Res>
    extends _$AnswerResultCopyWithImpl<$Res, _$AnswerResultImpl>
    implements _$$AnswerResultImplCopyWith<$Res> {
  __$$AnswerResultImplCopyWithImpl(
      _$AnswerResultImpl _value, $Res Function(_$AnswerResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnswerResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCorrect = null,
    Object? correctOptionOrder = null,
  }) {
    return _then(_$AnswerResultImpl(
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      correctOptionOrder: null == correctOptionOrder
          ? _value.correctOptionOrder
          : correctOptionOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnswerResultImpl implements _AnswerResult {
  const _$AnswerResultImpl(
      {required this.isCorrect, required this.correctOptionOrder});

  factory _$AnswerResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerResultImplFromJson(json);

  @override
  final bool isCorrect;
  @override
  final int correctOptionOrder;

  @override
  String toString() {
    return 'AnswerResult(isCorrect: $isCorrect, correctOptionOrder: $correctOptionOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerResultImpl &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.correctOptionOrder, correctOptionOrder) ||
                other.correctOptionOrder == correctOptionOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isCorrect, correctOptionOrder);

  /// Create a copy of AnswerResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerResultImplCopyWith<_$AnswerResultImpl> get copyWith =>
      __$$AnswerResultImplCopyWithImpl<_$AnswerResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerResultImplToJson(
      this,
    );
  }
}

abstract class _AnswerResult implements AnswerResult {
  const factory _AnswerResult(
      {required final bool isCorrect,
      required final int correctOptionOrder}) = _$AnswerResultImpl;

  factory _AnswerResult.fromJson(Map<String, dynamic> json) =
      _$AnswerResultImpl.fromJson;

  @override
  bool get isCorrect;
  @override
  int get correctOptionOrder;

  /// Create a copy of AnswerResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnswerResultImplCopyWith<_$AnswerResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserAnswer _$UserAnswerFromJson(Map<String, dynamic> json) {
  return _UserAnswer.fromJson(json);
}

/// @nodoc
mixin _$UserAnswer {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get questionId => throw _privateConstructorUsedError;
  int get selectedOptionOrder => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;
  double? get responseTimeSec => throw _privateConstructorUsedError;

  /// Serializes this UserAnswer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserAnswerCopyWith<UserAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAnswerCopyWith<$Res> {
  factory $UserAnswerCopyWith(
          UserAnswer value, $Res Function(UserAnswer) then) =
      _$UserAnswerCopyWithImpl<$Res, UserAnswer>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String questionId,
      int selectedOptionOrder,
      bool isCorrect,
      double? responseTimeSec});
}

/// @nodoc
class _$UserAnswerCopyWithImpl<$Res, $Val extends UserAnswer>
    implements $UserAnswerCopyWith<$Res> {
  _$UserAnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionId = null,
    Object? selectedOptionOrder = null,
    Object? isCorrect = null,
    Object? responseTimeSec = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedOptionOrder: null == selectedOptionOrder
          ? _value.selectedOptionOrder
          : selectedOptionOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      responseTimeSec: freezed == responseTimeSec
          ? _value.responseTimeSec
          : responseTimeSec // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserAnswerImplCopyWith<$Res>
    implements $UserAnswerCopyWith<$Res> {
  factory _$$UserAnswerImplCopyWith(
          _$UserAnswerImpl value, $Res Function(_$UserAnswerImpl) then) =
      __$$UserAnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String questionId,
      int selectedOptionOrder,
      bool isCorrect,
      double? responseTimeSec});
}

/// @nodoc
class __$$UserAnswerImplCopyWithImpl<$Res>
    extends _$UserAnswerCopyWithImpl<$Res, _$UserAnswerImpl>
    implements _$$UserAnswerImplCopyWith<$Res> {
  __$$UserAnswerImplCopyWithImpl(
      _$UserAnswerImpl _value, $Res Function(_$UserAnswerImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionId = null,
    Object? selectedOptionOrder = null,
    Object? isCorrect = null,
    Object? responseTimeSec = freezed,
  }) {
    return _then(_$UserAnswerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedOptionOrder: null == selectedOptionOrder
          ? _value.selectedOptionOrder
          : selectedOptionOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      responseTimeSec: freezed == responseTimeSec
          ? _value.responseTimeSec
          : responseTimeSec // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserAnswerImpl implements _UserAnswer {
  const _$UserAnswerImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.questionId,
      required this.selectedOptionOrder,
      required this.isCorrect,
      this.responseTimeSec});

  factory _$UserAnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserAnswerImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String questionId;
  @override
  final int selectedOptionOrder;
  @override
  final bool isCorrect;
  @override
  final double? responseTimeSec;

  @override
  String toString() {
    return 'UserAnswer(id: $id, questionId: $questionId, selectedOptionOrder: $selectedOptionOrder, isCorrect: $isCorrect, responseTimeSec: $responseTimeSec)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAnswerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.selectedOptionOrder, selectedOptionOrder) ||
                other.selectedOptionOrder == selectedOptionOrder) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.responseTimeSec, responseTimeSec) ||
                other.responseTimeSec == responseTimeSec));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, questionId,
      selectedOptionOrder, isCorrect, responseTimeSec);

  /// Create a copy of UserAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserAnswerImplCopyWith<_$UserAnswerImpl> get copyWith =>
      __$$UserAnswerImplCopyWithImpl<_$UserAnswerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserAnswerImplToJson(
      this,
    );
  }
}

abstract class _UserAnswer implements UserAnswer {
  const factory _UserAnswer(
      {@JsonKey(name: '_id') required final String id,
      required final String questionId,
      required final int selectedOptionOrder,
      required final bool isCorrect,
      final double? responseTimeSec}) = _$UserAnswerImpl;

  factory _UserAnswer.fromJson(Map<String, dynamic> json) =
      _$UserAnswerImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get questionId;
  @override
  int get selectedOptionOrder;
  @override
  bool get isCorrect;
  @override
  double? get responseTimeSec;

  /// Create a copy of UserAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserAnswerImplCopyWith<_$UserAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionResult _$SessionResultFromJson(Map<String, dynamic> json) {
  return _SessionResult.fromJson(json);
}

/// @nodoc
mixin _$SessionResult {
  TestSession get session => throw _privateConstructorUsedError;
  List<UserAnswer> get answers => throw _privateConstructorUsedError;

  /// Serializes this SessionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionResultCopyWith<SessionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionResultCopyWith<$Res> {
  factory $SessionResultCopyWith(
          SessionResult value, $Res Function(SessionResult) then) =
      _$SessionResultCopyWithImpl<$Res, SessionResult>;
  @useResult
  $Res call({TestSession session, List<UserAnswer> answers});

  $TestSessionCopyWith<$Res> get session;
}

/// @nodoc
class _$SessionResultCopyWithImpl<$Res, $Val extends SessionResult>
    implements $SessionResultCopyWith<$Res> {
  _$SessionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? answers = null,
  }) {
    return _then(_value.copyWith(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as TestSession,
      answers: null == answers
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<UserAnswer>,
    ) as $Val);
  }

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TestSessionCopyWith<$Res> get session {
    return $TestSessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionResultImplCopyWith<$Res>
    implements $SessionResultCopyWith<$Res> {
  factory _$$SessionResultImplCopyWith(
          _$SessionResultImpl value, $Res Function(_$SessionResultImpl) then) =
      __$$SessionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TestSession session, List<UserAnswer> answers});

  @override
  $TestSessionCopyWith<$Res> get session;
}

/// @nodoc
class __$$SessionResultImplCopyWithImpl<$Res>
    extends _$SessionResultCopyWithImpl<$Res, _$SessionResultImpl>
    implements _$$SessionResultImplCopyWith<$Res> {
  __$$SessionResultImplCopyWithImpl(
      _$SessionResultImpl _value, $Res Function(_$SessionResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? answers = null,
  }) {
    return _then(_$SessionResultImpl(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as TestSession,
      answers: null == answers
          ? _value._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<UserAnswer>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionResultImpl implements _SessionResult {
  const _$SessionResultImpl(
      {required this.session, required final List<UserAnswer> answers})
      : _answers = answers;

  factory _$SessionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionResultImplFromJson(json);

  @override
  final TestSession session;
  final List<UserAnswer> _answers;
  @override
  List<UserAnswer> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  String toString() {
    return 'SessionResult(session: $session, answers: $answers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionResultImpl &&
            (identical(other.session, session) || other.session == session) &&
            const DeepCollectionEquality().equals(other._answers, _answers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, session, const DeepCollectionEquality().hash(_answers));

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionResultImplCopyWith<_$SessionResultImpl> get copyWith =>
      __$$SessionResultImplCopyWithImpl<_$SessionResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionResultImplToJson(
      this,
    );
  }
}

abstract class _SessionResult implements SessionResult {
  const factory _SessionResult(
      {required final TestSession session,
      required final List<UserAnswer> answers}) = _$SessionResultImpl;

  factory _SessionResult.fromJson(Map<String, dynamic> json) =
      _$SessionResultImpl.fromJson;

  @override
  TestSession get session;
  @override
  List<UserAnswer> get answers;

  /// Create a copy of SessionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionResultImplCopyWith<_$SessionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
