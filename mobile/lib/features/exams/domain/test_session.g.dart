// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestSessionImpl _$$TestSessionImplFromJson(Map<String, dynamic> json) =>
    _$TestSessionImpl(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      companyId: json['companyId'] as String,
      weekNumber: (json['weekNumber'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      questionIds: (json['questionIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      correctCount: (json['correctCount'] as num?)?.toInt() ?? 0,
      scorePercent: (json['scorePercent'] as num?)?.toInt() ?? 0,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      sessionType: json['sessionType'] as String? ?? 'weekly',
    );

Map<String, dynamic> _$$TestSessionImplToJson(_$TestSessionImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'companyId': instance.companyId,
      'weekNumber': instance.weekNumber,
      'year': instance.year,
      'questionIds': instance.questionIds,
      'totalQuestions': instance.totalQuestions,
      'correctCount': instance.correctCount,
      'scorePercent': instance.scorePercent,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'sessionType': instance.sessionType,
    };

_$SessionQuestionsPayloadImpl _$$SessionQuestionsPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$SessionQuestionsPayloadImpl(
      session: TestSession.fromJson(json['session'] as Map<String, dynamic>),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => ExamQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SessionQuestionsPayloadImplToJson(
        _$SessionQuestionsPayloadImpl instance) =>
    <String, dynamic>{
      'session': instance.session,
      'questions': instance.questions,
    };

_$AnswerRequestImpl _$$AnswerRequestImplFromJson(Map<String, dynamic> json) =>
    _$AnswerRequestImpl(
      questionId: json['questionId'] as String,
      selectedOptionOrder: (json['selectedOptionOrder'] as num).toInt(),
      responseTimeSec: (json['responseTimeSec'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$AnswerRequestImplToJson(_$AnswerRequestImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'selectedOptionOrder': instance.selectedOptionOrder,
      'responseTimeSec': instance.responseTimeSec,
    };

_$AnswerResultImpl _$$AnswerResultImplFromJson(Map<String, dynamic> json) =>
    _$AnswerResultImpl(
      isCorrect: json['isCorrect'] as bool,
      correctOptionOrder: (json['correctOptionOrder'] as num).toInt(),
    );

Map<String, dynamic> _$$AnswerResultImplToJson(_$AnswerResultImpl instance) =>
    <String, dynamic>{
      'isCorrect': instance.isCorrect,
      'correctOptionOrder': instance.correctOptionOrder,
    };

_$UserAnswerImpl _$$UserAnswerImplFromJson(Map<String, dynamic> json) =>
    _$UserAnswerImpl(
      id: json['_id'] as String,
      questionId: json['questionId'] as String,
      selectedOptionOrder: (json['selectedOptionOrder'] as num).toInt(),
      isCorrect: json['isCorrect'] as bool,
      responseTimeSec: (json['responseTimeSec'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$UserAnswerImplToJson(_$UserAnswerImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'questionId': instance.questionId,
      'selectedOptionOrder': instance.selectedOptionOrder,
      'isCorrect': instance.isCorrect,
      'responseTimeSec': instance.responseTimeSec,
    };

_$SessionResultImpl _$$SessionResultImplFromJson(Map<String, dynamic> json) =>
    _$SessionResultImpl(
      session: TestSession.fromJson(json['session'] as Map<String, dynamic>),
      answers: (json['answers'] as List<dynamic>)
          .map((e) => UserAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SessionResultImplToJson(_$SessionResultImpl instance) =>
    <String, dynamic>{
      'session': instance.session,
      'answers': instance.answers,
    };
