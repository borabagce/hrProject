// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExamOptionImpl _$$ExamOptionImplFromJson(Map<String, dynamic> json) =>
    _$ExamOptionImpl(
      text: json['text'] as String,
      order: (json['order'] as num).toInt(),
      isCorrect: json['isCorrect'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExamOptionImplToJson(_$ExamOptionImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'order': instance.order,
      'isCorrect': instance.isCorrect,
    };

_$ExamQuestionImpl _$$ExamQuestionImplFromJson(Map<String, dynamic> json) =>
    _$ExamQuestionImpl(
      id: json['_id'] as String,
      text: json['text'] as String,
      type: json['type'] as String,
      difficulty: (json['difficulty'] as num).toInt(),
      categoryId: json['categoryId'] as String?,
      options: (json['options'] as List<dynamic>)
          .map((e) => ExamOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      isAnswered: json['isAnswered'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExamQuestionImplToJson(_$ExamQuestionImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
      'type': instance.type,
      'difficulty': instance.difficulty,
      'categoryId': instance.categoryId,
      'options': instance.options,
      'isAnswered': instance.isAnswered,
    };
