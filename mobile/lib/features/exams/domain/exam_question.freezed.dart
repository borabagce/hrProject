// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExamOption _$ExamOptionFromJson(Map<String, dynamic> json) {
  return _ExamOption.fromJson(json);
}

/// @nodoc
mixin _$ExamOption {
  String get text => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;

  /// Serializes this ExamOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExamOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExamOptionCopyWith<ExamOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamOptionCopyWith<$Res> {
  factory $ExamOptionCopyWith(
          ExamOption value, $Res Function(ExamOption) then) =
      _$ExamOptionCopyWithImpl<$Res, ExamOption>;
  @useResult
  $Res call({String text, int order, bool isCorrect});
}

/// @nodoc
class _$ExamOptionCopyWithImpl<$Res, $Val extends ExamOption>
    implements $ExamOptionCopyWith<$Res> {
  _$ExamOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExamOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? order = null,
    Object? isCorrect = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExamOptionImplCopyWith<$Res>
    implements $ExamOptionCopyWith<$Res> {
  factory _$$ExamOptionImplCopyWith(
          _$ExamOptionImpl value, $Res Function(_$ExamOptionImpl) then) =
      __$$ExamOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, int order, bool isCorrect});
}

/// @nodoc
class __$$ExamOptionImplCopyWithImpl<$Res>
    extends _$ExamOptionCopyWithImpl<$Res, _$ExamOptionImpl>
    implements _$$ExamOptionImplCopyWith<$Res> {
  __$$ExamOptionImplCopyWithImpl(
      _$ExamOptionImpl _value, $Res Function(_$ExamOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExamOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? order = null,
    Object? isCorrect = null,
  }) {
    return _then(_$ExamOptionImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamOptionImpl implements _ExamOption {
  const _$ExamOptionImpl(
      {required this.text, required this.order, this.isCorrect = false});

  factory _$ExamOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamOptionImplFromJson(json);

  @override
  final String text;
  @override
  final int order;
  @override
  @JsonKey()
  final bool isCorrect;

  @override
  String toString() {
    return 'ExamOption(text: $text, order: $order, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamOptionImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, order, isCorrect);

  /// Create a copy of ExamOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamOptionImplCopyWith<_$ExamOptionImpl> get copyWith =>
      __$$ExamOptionImplCopyWithImpl<_$ExamOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamOptionImplToJson(
      this,
    );
  }
}

abstract class _ExamOption implements ExamOption {
  const factory _ExamOption(
      {required final String text,
      required final int order,
      final bool isCorrect}) = _$ExamOptionImpl;

  factory _ExamOption.fromJson(Map<String, dynamic> json) =
      _$ExamOptionImpl.fromJson;

  @override
  String get text;
  @override
  int get order;
  @override
  bool get isCorrect;

  /// Create a copy of ExamOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExamOptionImplCopyWith<_$ExamOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExamQuestion _$ExamQuestionFromJson(Map<String, dynamic> json) {
  return _ExamQuestion.fromJson(json);
}

/// @nodoc
mixin _$ExamQuestion {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  List<ExamOption> get options => throw _privateConstructorUsedError;
  bool get isAnswered => throw _privateConstructorUsedError;

  /// Serializes this ExamQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExamQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExamQuestionCopyWith<ExamQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamQuestionCopyWith<$Res> {
  factory $ExamQuestionCopyWith(
          ExamQuestion value, $Res Function(ExamQuestion) then) =
      _$ExamQuestionCopyWithImpl<$Res, ExamQuestion>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String text,
      String type,
      int difficulty,
      String? categoryId,
      List<ExamOption> options,
      bool isAnswered});
}

/// @nodoc
class _$ExamQuestionCopyWithImpl<$Res, $Val extends ExamQuestion>
    implements $ExamQuestionCopyWith<$Res> {
  _$ExamQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExamQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? difficulty = null,
    Object? categoryId = freezed,
    Object? options = null,
    Object? isAnswered = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<ExamOption>,
      isAnswered: null == isAnswered
          ? _value.isAnswered
          : isAnswered // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExamQuestionImplCopyWith<$Res>
    implements $ExamQuestionCopyWith<$Res> {
  factory _$$ExamQuestionImplCopyWith(
          _$ExamQuestionImpl value, $Res Function(_$ExamQuestionImpl) then) =
      __$$ExamQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String text,
      String type,
      int difficulty,
      String? categoryId,
      List<ExamOption> options,
      bool isAnswered});
}

/// @nodoc
class __$$ExamQuestionImplCopyWithImpl<$Res>
    extends _$ExamQuestionCopyWithImpl<$Res, _$ExamQuestionImpl>
    implements _$$ExamQuestionImplCopyWith<$Res> {
  __$$ExamQuestionImplCopyWithImpl(
      _$ExamQuestionImpl _value, $Res Function(_$ExamQuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExamQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? difficulty = null,
    Object? categoryId = freezed,
    Object? options = null,
    Object? isAnswered = null,
  }) {
    return _then(_$ExamQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<ExamOption>,
      isAnswered: null == isAnswered
          ? _value.isAnswered
          : isAnswered // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamQuestionImpl implements _ExamQuestion {
  const _$ExamQuestionImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.text,
      required this.type,
      required this.difficulty,
      this.categoryId,
      required final List<ExamOption> options,
      this.isAnswered = false})
      : _options = options;

  factory _$ExamQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamQuestionImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String text;
  @override
  final String type;
  @override
  final int difficulty;
  @override
  final String? categoryId;
  final List<ExamOption> _options;
  @override
  List<ExamOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  @JsonKey()
  final bool isAnswered;

  @override
  String toString() {
    return 'ExamQuestion(id: $id, text: $text, type: $type, difficulty: $difficulty, categoryId: $categoryId, options: $options, isAnswered: $isAnswered)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.isAnswered, isAnswered) ||
                other.isAnswered == isAnswered));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, type, difficulty,
      categoryId, const DeepCollectionEquality().hash(_options), isAnswered);

  /// Create a copy of ExamQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamQuestionImplCopyWith<_$ExamQuestionImpl> get copyWith =>
      __$$ExamQuestionImplCopyWithImpl<_$ExamQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamQuestionImplToJson(
      this,
    );
  }
}

abstract class _ExamQuestion implements ExamQuestion {
  const factory _ExamQuestion(
      {@JsonKey(name: '_id') required final String id,
      required final String text,
      required final String type,
      required final int difficulty,
      final String? categoryId,
      required final List<ExamOption> options,
      final bool isAnswered}) = _$ExamQuestionImpl;

  factory _ExamQuestion.fromJson(Map<String, dynamic> json) =
      _$ExamQuestionImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get text;
  @override
  String get type;
  @override
  int get difficulty;
  @override
  String? get categoryId;
  @override
  List<ExamOption> get options;
  @override
  bool get isAnswered;

  /// Create a copy of ExamQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExamQuestionImplCopyWith<_$ExamQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
