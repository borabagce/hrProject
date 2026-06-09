import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/storage/isar_db.dart';
import '../../../core/storage/isar_models.dart';
import '../domain/assignment.dart';
import '../domain/exam_question.dart';
import '../domain/test_session.dart';
import 'exam_api.dart';

part 'exam_repository.g.dart';

class ExamRepository {
  ExamRepository(this._api, this._db);

  final ExamApi _api;
  final IsarDb _db;

  Future<List<Assignment>> fetchAssignments({String? status}) async {
    try {
      final Map<String, dynamic> resp = await _api.myAssignments(status);
      final List<dynamic> list = (resp['data'] as List<dynamic>);
      final List<Assignment> assignments = list
          .map(
            (Object? e) => Assignment.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      await _cacheAssignments(assignments);
      return assignments;
    } catch (e, st) {
      final cached = await _readCachedAssignments();
      if (cached.isNotEmpty) return cached;
      throw mapDioError(e, st);
    }
  }

  Future<List<Assignment>> readCachedAssignments() => _readCachedAssignments();

  Future<TestSession> startAssignment(String id) async {
    try {
      final Map<String, dynamic> resp = await _api.startAssignment(id);
      return TestSession.fromJson(resp['data'] as Map<String, dynamic>);
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }

  Future<void> completeAssignment(String id) async {
    try {
      await _api.completeAssignment(id);
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }

  Future<SessionQuestionsPayload> fetchSessionQuestions(String id) async {
    try {
      final Map<String, dynamic> resp = await _api.sessionQuestions(id);
      final SessionQuestionsPayload payload = SessionQuestionsPayload.fromJson(
        resp['data'] as Map<String, dynamic>,
      );
      await _cacheQuestions(id, payload.questions);
      return payload;
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }

  Future<AnswerResult> submitAnswer(
    String sessionId,
    AnswerRequest req,
  ) async {
    try {
      final Map<String, dynamic> resp =
          await _api.submitAnswer(sessionId, <String, dynamic>{
        'questionId': req.questionId,
        'selectedOptionOrder': req.selectedOptionOrder,
        if (req.responseTimeSec != null) 'responseTimeSec': req.responseTimeSec,
      });
      return AnswerResult.fromJson(resp['data'] as Map<String, dynamic>);
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }

  Future<SessionResult> fetchSessionResult(String id) async {
    try {
      final Map<String, dynamic> resp = await _api.sessionResult(id);
      final SessionResult result = SessionResult.fromJson(
        resp['data'] as Map<String, dynamic>,
      );
      await _cacheResult(result);
      return result;
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }

  Map<String, IsarQuestion> getQuestionCacheBySession(String sessionId) {
    final Iterable<MapEntry<String, IsarQuestion>> matches =
        _db.questions.entries.where(
      (MapEntry<String, IsarQuestion> e) => e.value.sessionId == sessionId,
    );
    return Map<String, IsarQuestion>.fromEntries(matches);
  }

  Future<Map<String, IsarQuestion>> getOrFetchQuestionsForSession(
    String sessionId,
  ) async {
    final Map<String, IsarQuestion> cached =
        getQuestionCacheBySession(sessionId);
    if (cached.isNotEmpty) return cached;
    try {
      await fetchSessionQuestions(sessionId);
      return getQuestionCacheBySession(sessionId);
    } catch (_) {
      return <String, IsarQuestion>{};
    }
  }

  Future<List<TestSession>> fetchMySessions() async {
    try {
      final Map<String, dynamic> resp =
          await _api.mySessions(<String, dynamic>{'isCompleted': 'true'});
      final List<dynamic> list = resp['data'] as List<dynamic>;
      return list
          .map((Object? e) => TestSession.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }

  Future<void> _cacheAssignments(List<Assignment> assignments) async {
    _db.assignments.clear();
    for (final Assignment a in assignments) {
      _db.assignments[a.id] = IsarAssignment()
        ..assignmentId = a.id
        ..status = a.status.name
        ..testId = a.testId?.id
        ..testTitle = a.testId?.title
        ..difficulty = a.testId?.difficulty
        ..dueDate = a.dueDate
        ..completedAt = a.completedAt
        ..sessionId = a.sessionId
        ..cachedAt = DateTime.now();
    }
  }

  Future<List<Assignment>> _readCachedAssignments() async {
    return _db.assignments.values
        .map(
          (IsarAssignment r) => Assignment(
            id: r.assignmentId,
            status: _parseStatus(r.status),
            testId: r.testId == null
                ? null
                : AssignmentTest(
                    id: r.testId!,
                    title: r.testTitle ?? '',
                    type: 'multiple_choice',
                    difficulty: r.difficulty ?? 1,
                  ),
            dueDate: r.dueDate,
            completedAt: r.completedAt,
            sessionId: r.sessionId,
          ),
        )
        .toList();
  }

  AssignmentStatus _parseStatus(String raw) {
    switch (raw) {
      case 'in_progress':
      case 'inProgress':
        return AssignmentStatus.inProgress;
      case 'completed':
        return AssignmentStatus.completed;
      case 'expired':
        return AssignmentStatus.expired;
      default:
        return AssignmentStatus.pending;
    }
  }

  Future<void> _cacheQuestions(
    String sessionId,
    List<ExamQuestion> questions,
  ) async {
    _db.questions.removeWhere((_, q) => q.sessionId == sessionId);
    for (final ExamQuestion q in questions) {
      _db.questions[q.id] = IsarQuestion()
        ..questionId = q.id
        ..sessionId = sessionId
        ..text = q.text
        ..type = q.type
        ..difficulty = q.difficulty
        ..optionTexts = q.options.map((ExamOption o) => o.text).toList()
        ..optionOrders = q.options.map((ExamOption o) => o.order).toList()
        ..cachedAt = DateTime.now();
    }
  }

  Future<void> _cacheResult(SessionResult r) async {
    _db.sessionResults[r.session.id] = IsarSessionResult()
      ..sessionId = r.session.id
      ..scorePercent = r.session.scorePercent
      ..correctCount = r.session.correctCount
      ..totalQuestions = r.session.totalQuestions
      ..completedAt = r.session.completedAt
      ..cachedAt = DateTime.now();
  }
}

@Riverpod(keepAlive: true)
Future<ExamRepository> examRepository(ExamRepositoryRef ref) async {
  final IsarDb db = await ref.watch(isarDbProvider.future);
  return ExamRepository(ref.watch(examApiProvider), db);
}
