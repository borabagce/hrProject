import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_question.freezed.dart';
part 'exam_question.g.dart';

@freezed
class ExamOption with _$ExamOption {
  const factory ExamOption({
    required String text,
    required int order,
    @Default(false) bool isCorrect,
  }) = _ExamOption;

  factory ExamOption.fromJson(Map<String, dynamic> json) =>
      _$ExamOptionFromJson(json);
}

@freezed
class ExamQuestion with _$ExamQuestion {
  const factory ExamQuestion({
    @JsonKey(name: '_id') required String id,
    required String text,
    required String type,
    required int difficulty,
    String? categoryId,
    required List<ExamOption> options,
    @Default(false) bool isAnswered,
  }) = _ExamQuestion;

  factory ExamQuestion.fromJson(Map<String, dynamic> json) =>
      _$ExamQuestionFromJson(json);
}
