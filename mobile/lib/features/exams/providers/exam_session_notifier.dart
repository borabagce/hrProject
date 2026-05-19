import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/exam_repository.dart';
import '../domain/exam_question.dart';
import '../domain/test_session.dart';

part 'exam_session_notifier.freezed.dart';
part 'exam_session_notifier.g.dart';

@freezed
class ExamSessionState with _$ExamSessionState {
  const factory ExamSessionState({
    required TestSession session,
    required List<ExamQuestion> questions,
    required int currentIndex,
    @Default(<String, int>{}) Map<String, int> selectedByQuestionId,
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _ExamSessionState;
}

@riverpod
class ExamSessionNotifier extends _$ExamSessionNotifier {
  @override
  Future<ExamSessionState> build(String sessionId) async {
    final ExamRepository repo = await ref.watch(examRepositoryProvider.future);
    final SessionQuestionsPayload payload =
        await repo.fetchSessionQuestions(sessionId);
    final int firstUnansweredIdx = payload.questions.indexWhere(
      (ExamQuestion q) => !q.isAnswered,
    );
    return ExamSessionState(
      session: payload.session,
      questions: payload.questions,
      currentIndex: firstUnansweredIdx < 0 ? 0 : firstUnansweredIdx,
    );
  }

  void select(String questionId, int order) {
    final ExamSessionState? current = state.valueOrNull;
    if (current == null) return;
    final Map<String, int> next =
        Map<String, int>.from(current.selectedByQuestionId);
    next[questionId] = order;
    state = AsyncValue<ExamSessionState>.data(
      current.copyWith(selectedByQuestionId: next),
    );
  }

  void goTo(int index) {
    final ExamSessionState? current = state.valueOrNull;
    if (current == null) return;
    if (index < 0 || index >= current.questions.length) return;
    state = AsyncValue<ExamSessionState>.data(
      current.copyWith(currentIndex: index),
    );
  }

  Future<AnswerResult?> submitCurrent({double? responseTimeSec}) async {
    final ExamSessionState? current = state.valueOrNull;
    if (current == null) return null;
    final ExamQuestion q = current.questions[current.currentIndex];
    final int? selected = current.selectedByQuestionId[q.id];
    if (selected == null) return null;

    state = AsyncValue<ExamSessionState>.data(
      current.copyWith(isSubmitting: true, errorMessage: null),
    );

    try {
      final ExamRepository repo =
          await ref.read(examRepositoryProvider.future);
      final AnswerResult result = await repo.submitAnswer(
        current.session.id,
        AnswerRequest(
          questionId: q.id,
          selectedOptionOrder: selected,
          responseTimeSec: responseTimeSec,
        ),
      );
      state = AsyncValue<ExamSessionState>.data(
        current.copyWith(isSubmitting: false),
      );
      return result;
    } catch (e) {
      state = AsyncValue<ExamSessionState>.data(
        current.copyWith(
          isSubmitting: false,
          errorMessage: e.toString(),
        ),
      );
      return null;
    }
  }
}
