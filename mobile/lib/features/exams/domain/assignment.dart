import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignment.freezed.dart';
part 'assignment.g.dart';

enum AssignmentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('expired')
  expired,
}

@freezed
class AssignmentTest with _$AssignmentTest {
  const factory AssignmentTest({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String type,
    required int difficulty,
  }) = _AssignmentTest;

  factory AssignmentTest.fromJson(Map<String, dynamic> json) =>
      _$AssignmentTestFromJson(json);
}

@freezed
class AssignedBy with _$AssignedBy {
  const factory AssignedBy({
    @JsonKey(name: '_id') required String id,
    required String fullName,
  }) = _AssignedBy;

  factory AssignedBy.fromJson(Map<String, dynamic> json) =>
      _$AssignedByFromJson(json);
}

@freezed
class Assignment with _$Assignment {
  const factory Assignment({
    @JsonKey(name: '_id') required String id,
    AssignmentTest? testId,
    AssignedBy? assignedBy,
    required AssignmentStatus status,
    DateTime? dueDate,
    DateTime? completedAt,
    String? sessionId,
  }) = _Assignment;

  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson(json);
}
