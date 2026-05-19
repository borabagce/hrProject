// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assignment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AssignmentTest _$AssignmentTestFromJson(Map<String, dynamic> json) {
  return _AssignmentTest.fromJson(json);
}

/// @nodoc
mixin _$AssignmentTest {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;

  /// Serializes this AssignmentTest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssignmentTest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssignmentTestCopyWith<AssignmentTest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignmentTestCopyWith<$Res> {
  factory $AssignmentTestCopyWith(
          AssignmentTest value, $Res Function(AssignmentTest) then) =
      _$AssignmentTestCopyWithImpl<$Res, AssignmentTest>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String title,
      String type,
      int difficulty});
}

/// @nodoc
class _$AssignmentTestCopyWithImpl<$Res, $Val extends AssignmentTest>
    implements $AssignmentTestCopyWith<$Res> {
  _$AssignmentTestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssignmentTest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? difficulty = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssignmentTestImplCopyWith<$Res>
    implements $AssignmentTestCopyWith<$Res> {
  factory _$$AssignmentTestImplCopyWith(_$AssignmentTestImpl value,
          $Res Function(_$AssignmentTestImpl) then) =
      __$$AssignmentTestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String title,
      String type,
      int difficulty});
}

/// @nodoc
class __$$AssignmentTestImplCopyWithImpl<$Res>
    extends _$AssignmentTestCopyWithImpl<$Res, _$AssignmentTestImpl>
    implements _$$AssignmentTestImplCopyWith<$Res> {
  __$$AssignmentTestImplCopyWithImpl(
      _$AssignmentTestImpl _value, $Res Function(_$AssignmentTestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AssignmentTest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? difficulty = null,
  }) {
    return _then(_$AssignmentTestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignmentTestImpl implements _AssignmentTest {
  const _$AssignmentTestImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.title,
      required this.type,
      required this.difficulty});

  factory _$AssignmentTestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignmentTestImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String title;
  @override
  final String type;
  @override
  final int difficulty;

  @override
  String toString() {
    return 'AssignmentTest(id: $id, title: $title, type: $type, difficulty: $difficulty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignmentTestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, type, difficulty);

  /// Create a copy of AssignmentTest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignmentTestImplCopyWith<_$AssignmentTestImpl> get copyWith =>
      __$$AssignmentTestImplCopyWithImpl<_$AssignmentTestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignmentTestImplToJson(
      this,
    );
  }
}

abstract class _AssignmentTest implements AssignmentTest {
  const factory _AssignmentTest(
      {@JsonKey(name: '_id') required final String id,
      required final String title,
      required final String type,
      required final int difficulty}) = _$AssignmentTestImpl;

  factory _AssignmentTest.fromJson(Map<String, dynamic> json) =
      _$AssignmentTestImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get title;
  @override
  String get type;
  @override
  int get difficulty;

  /// Create a copy of AssignmentTest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssignmentTestImplCopyWith<_$AssignmentTestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AssignedBy _$AssignedByFromJson(Map<String, dynamic> json) {
  return _AssignedBy.fromJson(json);
}

/// @nodoc
mixin _$AssignedBy {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;

  /// Serializes this AssignedBy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssignedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssignedByCopyWith<AssignedBy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignedByCopyWith<$Res> {
  factory $AssignedByCopyWith(
          AssignedBy value, $Res Function(AssignedBy) then) =
      _$AssignedByCopyWithImpl<$Res, AssignedBy>;
  @useResult
  $Res call({@JsonKey(name: '_id') String id, String fullName});
}

/// @nodoc
class _$AssignedByCopyWithImpl<$Res, $Val extends AssignedBy>
    implements $AssignedByCopyWith<$Res> {
  _$AssignedByCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssignedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssignedByImplCopyWith<$Res>
    implements $AssignedByCopyWith<$Res> {
  factory _$$AssignedByImplCopyWith(
          _$AssignedByImpl value, $Res Function(_$AssignedByImpl) then) =
      __$$AssignedByImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: '_id') String id, String fullName});
}

/// @nodoc
class __$$AssignedByImplCopyWithImpl<$Res>
    extends _$AssignedByCopyWithImpl<$Res, _$AssignedByImpl>
    implements _$$AssignedByImplCopyWith<$Res> {
  __$$AssignedByImplCopyWithImpl(
      _$AssignedByImpl _value, $Res Function(_$AssignedByImpl) _then)
      : super(_value, _then);

  /// Create a copy of AssignedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
  }) {
    return _then(_$AssignedByImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignedByImpl implements _AssignedBy {
  const _$AssignedByImpl(
      {@JsonKey(name: '_id') required this.id, required this.fullName});

  factory _$AssignedByImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignedByImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String fullName;

  @override
  String toString() {
    return 'AssignedBy(id: $id, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignedByImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName);

  /// Create a copy of AssignedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignedByImplCopyWith<_$AssignedByImpl> get copyWith =>
      __$$AssignedByImplCopyWithImpl<_$AssignedByImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignedByImplToJson(
      this,
    );
  }
}

abstract class _AssignedBy implements AssignedBy {
  const factory _AssignedBy(
      {@JsonKey(name: '_id') required final String id,
      required final String fullName}) = _$AssignedByImpl;

  factory _AssignedBy.fromJson(Map<String, dynamic> json) =
      _$AssignedByImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get fullName;

  /// Create a copy of AssignedBy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssignedByImplCopyWith<_$AssignedByImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Assignment _$AssignmentFromJson(Map<String, dynamic> json) {
  return _Assignment.fromJson(json);
}

/// @nodoc
mixin _$Assignment {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  AssignmentTest? get testId => throw _privateConstructorUsedError;
  AssignedBy? get assignedBy => throw _privateConstructorUsedError;
  AssignmentStatus get status => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;

  /// Serializes this Assignment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Assignment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssignmentCopyWith<Assignment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignmentCopyWith<$Res> {
  factory $AssignmentCopyWith(
          Assignment value, $Res Function(Assignment) then) =
      _$AssignmentCopyWithImpl<$Res, Assignment>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      AssignmentTest? testId,
      AssignedBy? assignedBy,
      AssignmentStatus status,
      DateTime? dueDate,
      DateTime? completedAt,
      String? sessionId});

  $AssignmentTestCopyWith<$Res>? get testId;
  $AssignedByCopyWith<$Res>? get assignedBy;
}

/// @nodoc
class _$AssignmentCopyWithImpl<$Res, $Val extends Assignment>
    implements $AssignmentCopyWith<$Res> {
  _$AssignmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Assignment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? testId = freezed,
    Object? assignedBy = freezed,
    Object? status = null,
    Object? dueDate = freezed,
    Object? completedAt = freezed,
    Object? sessionId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      testId: freezed == testId
          ? _value.testId
          : testId // ignore: cast_nullable_to_non_nullable
              as AssignmentTest?,
      assignedBy: freezed == assignedBy
          ? _value.assignedBy
          : assignedBy // ignore: cast_nullable_to_non_nullable
              as AssignedBy?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AssignmentStatus,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of Assignment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssignmentTestCopyWith<$Res>? get testId {
    if (_value.testId == null) {
      return null;
    }

    return $AssignmentTestCopyWith<$Res>(_value.testId!, (value) {
      return _then(_value.copyWith(testId: value) as $Val);
    });
  }

  /// Create a copy of Assignment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AssignedByCopyWith<$Res>? get assignedBy {
    if (_value.assignedBy == null) {
      return null;
    }

    return $AssignedByCopyWith<$Res>(_value.assignedBy!, (value) {
      return _then(_value.copyWith(assignedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AssignmentImplCopyWith<$Res>
    implements $AssignmentCopyWith<$Res> {
  factory _$$AssignmentImplCopyWith(
          _$AssignmentImpl value, $Res Function(_$AssignmentImpl) then) =
      __$$AssignmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      AssignmentTest? testId,
      AssignedBy? assignedBy,
      AssignmentStatus status,
      DateTime? dueDate,
      DateTime? completedAt,
      String? sessionId});

  @override
  $AssignmentTestCopyWith<$Res>? get testId;
  @override
  $AssignedByCopyWith<$Res>? get assignedBy;
}

/// @nodoc
class __$$AssignmentImplCopyWithImpl<$Res>
    extends _$AssignmentCopyWithImpl<$Res, _$AssignmentImpl>
    implements _$$AssignmentImplCopyWith<$Res> {
  __$$AssignmentImplCopyWithImpl(
      _$AssignmentImpl _value, $Res Function(_$AssignmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Assignment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? testId = freezed,
    Object? assignedBy = freezed,
    Object? status = null,
    Object? dueDate = freezed,
    Object? completedAt = freezed,
    Object? sessionId = freezed,
  }) {
    return _then(_$AssignmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      testId: freezed == testId
          ? _value.testId
          : testId // ignore: cast_nullable_to_non_nullable
              as AssignmentTest?,
      assignedBy: freezed == assignedBy
          ? _value.assignedBy
          : assignedBy // ignore: cast_nullable_to_non_nullable
              as AssignedBy?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AssignmentStatus,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignmentImpl implements _Assignment {
  const _$AssignmentImpl(
      {@JsonKey(name: '_id') required this.id,
      this.testId,
      this.assignedBy,
      required this.status,
      this.dueDate,
      this.completedAt,
      this.sessionId});

  factory _$AssignmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignmentImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final AssignmentTest? testId;
  @override
  final AssignedBy? assignedBy;
  @override
  final AssignmentStatus status;
  @override
  final DateTime? dueDate;
  @override
  final DateTime? completedAt;
  @override
  final String? sessionId;

  @override
  String toString() {
    return 'Assignment(id: $id, testId: $testId, assignedBy: $assignedBy, status: $status, dueDate: $dueDate, completedAt: $completedAt, sessionId: $sessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.testId, testId) || other.testId == testId) &&
            (identical(other.assignedBy, assignedBy) ||
                other.assignedBy == assignedBy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, testId, assignedBy, status,
      dueDate, completedAt, sessionId);

  /// Create a copy of Assignment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignmentImplCopyWith<_$AssignmentImpl> get copyWith =>
      __$$AssignmentImplCopyWithImpl<_$AssignmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignmentImplToJson(
      this,
    );
  }
}

abstract class _Assignment implements Assignment {
  const factory _Assignment(
      {@JsonKey(name: '_id') required final String id,
      final AssignmentTest? testId,
      final AssignedBy? assignedBy,
      required final AssignmentStatus status,
      final DateTime? dueDate,
      final DateTime? completedAt,
      final String? sessionId}) = _$AssignmentImpl;

  factory _Assignment.fromJson(Map<String, dynamic> json) =
      _$AssignmentImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  AssignmentTest? get testId;
  @override
  AssignedBy? get assignedBy;
  @override
  AssignmentStatus get status;
  @override
  DateTime? get dueDate;
  @override
  DateTime? get completedAt;
  @override
  String? get sessionId;

  /// Create a copy of Assignment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssignmentImplCopyWith<_$AssignmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
