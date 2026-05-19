// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssignmentTestImpl _$$AssignmentTestImplFromJson(Map<String, dynamic> json) =>
    _$AssignmentTestImpl(
      id: json['_id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      difficulty: (json['difficulty'] as num).toInt(),
    );

Map<String, dynamic> _$$AssignmentTestImplToJson(
        _$AssignmentTestImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'difficulty': instance.difficulty,
    };

_$AssignedByImpl _$$AssignedByImplFromJson(Map<String, dynamic> json) =>
    _$AssignedByImpl(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
    );

Map<String, dynamic> _$$AssignedByImplToJson(_$AssignedByImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
    };

_$AssignmentImpl _$$AssignmentImplFromJson(Map<String, dynamic> json) =>
    _$AssignmentImpl(
      id: json['_id'] as String,
      testId: json['testId'] == null
          ? null
          : AssignmentTest.fromJson(json['testId'] as Map<String, dynamic>),
      assignedBy: json['assignedBy'] == null
          ? null
          : AssignedBy.fromJson(json['assignedBy'] as Map<String, dynamic>),
      status: $enumDecode(_$AssignmentStatusEnumMap, json['status']),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      sessionId: json['sessionId'] as String?,
    );

Map<String, dynamic> _$$AssignmentImplToJson(_$AssignmentImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'testId': instance.testId,
      'assignedBy': instance.assignedBy,
      'status': _$AssignmentStatusEnumMap[instance.status]!,
      'dueDate': instance.dueDate?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'sessionId': instance.sessionId,
    };

const _$AssignmentStatusEnumMap = {
  AssignmentStatus.pending: 'pending',
  AssignmentStatus.inProgress: 'in_progress',
  AssignmentStatus.completed: 'completed',
  AssignmentStatus.expired: 'expired',
};
