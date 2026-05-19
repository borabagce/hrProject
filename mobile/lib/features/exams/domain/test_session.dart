import 'package:freezed_annotation/freezed_annotation.dart';

import 'exam_question.dart';

part 'test_session.freezed.dart';
part 'test_session.g.dart';

@freezed
class TestSession with _$TestSession {
  const factory TestSession({
    @JsonKey(name: '_id') required String id,
    required String userId,
    required String companyId,
    required int weekNumber,
    required int year,
    required List<String> questionIds,
    required int totalQuestions,
    @Default(0) int correctCount,
    @Default(0) int scorePercent,
    DateTime? startedAt,
    DateTime? completedAt,
    @Default(false) bool isCompleted,
    @Default('weekly') String sessionType,
  }) = _TestSession;

  factory TestSession.fromJson(Map<String, dynamic> json) =>
      _$TestSessionFromJson(json);
}

@freezed
class SessionQuestionsPayload with _$SessionQuestionsPayload {
  const factory SessionQuestionsPayload({
    required TestSession session,
    required List<ExamQuestion> questions,
  }) = _SessionQuestionsPayload;

  factory SessionQuestionsPayload.fromJson(Map<String, dynamic> json) =>
      _$SessionQuestionsPayloadFromJson(json);
}

@freezed
class AnswerRequest with _$AnswerRequest {
  const factory AnswerRequest({
    required String questionId,
    required int selectedOptionOrder,
    double? responseTimeSec,
  }) = _AnswerRequest;

  factory AnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$AnswerRequestFromJson(json);
}

@freezed
class AnswerResult with _$AnswerResult {
  const factory AnswerResult({
    required bool isCorrect,
    required int correctOptionOrder,
  }) = _AnswerResult;

  factory AnswerResult.fromJson(Map<String, dynamic> json) =>
      _$AnswerResultFromJson(json);
}

@freezed
class UserAnswer with _$UserAnswer {
  const factory UserAnswer({
    @JsonKey(name: '_id') required String id,
    required String questionId,
    required int selectedOptionOrder,
    required bool isCorrect,
    double? responseTimeSec,
  }) = _UserAnswer;

  factory UserAnswer.fromJson(Map<String, dynamic> json) =>
      _$UserAnswerFromJson(json);
}

@freezed
class SessionResult with _$SessionResult {
  const factory SessionResult({
    required TestSession session,
    required List<UserAnswer> answers,
  }) = _SessionResult;

  factory SessionResult.fromJson(Map<String, dynamic> json) =>
      _$SessionResultFromJson(json);
}
