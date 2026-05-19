// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_session_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExamSessionState {
  TestSession get session => throw _privateConstructorUsedError;
  List<ExamQuestion> get questions => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;
  Map<String, int> get selectedByQuestionId =>
      throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of ExamSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExamSessionStateCopyWith<ExamSessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamSessionStateCopyWith<$Res> {
  factory $ExamSessionStateCopyWith(
          ExamSessionState value, $Res Function(ExamSessionState) then) =
      _$ExamSessionStateCopyWithImpl<$Res, ExamSessionState>;
  @useResult
  $Res call(
      {TestSession session,
      List<ExamQuestion> questions,
      int currentIndex,
      Map<String, int> selectedByQuestionId,
      bool isSubmitting,
      String? errorMessage});

  $TestSessionCopyWith<$Res> get session;
}

/// @nodoc
class _$ExamSessionStateCopyWithImpl<$Res, $Val extends ExamSessionState>
    implements $ExamSessionStateCopyWith<$Res> {
  _$ExamSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExamSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? questions = null,
    Object? currentIndex = null,
    Object? selectedByQuestionId = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
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
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectedByQuestionId: null == selectedByQuestionId
          ? _value.selectedByQuestionId
          : selectedByQuestionId // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ExamSessionState
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
abstract class _$$ExamSessionStateImplCopyWith<$Res>
    implements $ExamSessionStateCopyWith<$Res> {
  factory _$$ExamSessionStateImplCopyWith(_$ExamSessionStateImpl value,
          $Res Function(_$ExamSessionStateImpl) then) =
      __$$ExamSessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TestSession session,
      List<ExamQuestion> questions,
      int currentIndex,
      Map<String, int> selectedByQuestionId,
      bool isSubmitting,
      String? errorMessage});

  @override
  $TestSessionCopyWith<$Res> get session;
}

/// @nodoc
class __$$ExamSessionStateImplCopyWithImpl<$Res>
    extends _$ExamSessionStateCopyWithImpl<$Res, _$ExamSessionStateImpl>
    implements _$$ExamSessionStateImplCopyWith<$Res> {
  __$$ExamSessionStateImplCopyWithImpl(_$ExamSessionStateImpl _value,
      $Res Function(_$ExamSessionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExamSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? questions = null,
    Object? currentIndex = null,
    Object? selectedByQuestionId = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ExamSessionStateImpl(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as TestSession,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<ExamQuestion>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectedByQuestionId: null == selectedByQuestionId
          ? _value._selectedByQuestionId
          : selectedByQuestionId // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ExamSessionStateImpl implements _ExamSessionState {
  const _$ExamSessionStateImpl(
      {required this.session,
      required final List<ExamQuestion> questions,
      required this.currentIndex,
      final Map<String, int> selectedByQuestionId = const <String, int>{},
      this.isSubmitting = false,
      this.errorMessage})
      : _questions = questions,
        _selectedByQuestionId = selectedByQuestionId;

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
  final int currentIndex;
  final Map<String, int> _selectedByQuestionId;
  @override
  @JsonKey()
  Map<String, int> get selectedByQuestionId {
    if (_selectedByQuestionId is EqualUnmodifiableMapView)
      return _selectedByQuestionId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selectedByQuestionId);
  }

  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ExamSessionState(session: $session, questions: $questions, currentIndex: $currentIndex, selectedByQuestionId: $selectedByQuestionId, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamSessionStateImpl &&
            (identical(other.session, session) || other.session == session) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            const DeepCollectionEquality()
                .equals(other._selectedByQuestionId, _selectedByQuestionId) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      session,
      const DeepCollectionEquality().hash(_questions),
      currentIndex,
      const DeepCollectionEquality().hash(_selectedByQuestionId),
      isSubmitting,
      errorMessage);

  /// Create a copy of ExamSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamSessionStateImplCopyWith<_$ExamSessionStateImpl> get copyWith =>
      __$$ExamSessionStateImplCopyWithImpl<_$ExamSessionStateImpl>(
          this, _$identity);
}

abstract class _ExamSessionState implements ExamSessionState {
  const factory _ExamSessionState(
      {required final TestSession session,
      required final List<ExamQuestion> questions,
      required final int currentIndex,
      final Map<String, int> selectedByQuestionId,
      final bool isSubmitting,
      final String? errorMessage}) = _$ExamSessionStateImpl;

  @override
  TestSession get session;
  @override
  List<ExamQuestion> get questions;
  @override
  int get currentIndex;
  @override
  Map<String, int> get selectedByQuestionId;
  @override
  bool get isSubmitting;
  @override
  String? get errorMessage;

  /// Create a copy of ExamSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExamSessionStateImplCopyWith<_$ExamSessionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
