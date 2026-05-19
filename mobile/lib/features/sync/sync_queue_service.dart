import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/providers.dart';
import '../../core/storage/isar_db.dart';
import '../../core/storage/isar_models.dart';
import '../exams/data/exam_repository.dart';
import '../exams/domain/test_session.dart';

part 'sync_queue_service.g.dart';

class SyncQueueService {
  SyncQueueService(this._db, this._repo);

  final IsarDb _db;
  final ExamRepository _repo;

  Future<void> enqueueAnswer({
    required String sessionId,
    required String questionId,
    required int selectedOptionOrder,
    double? responseTimeSec,
  }) async {
    final IsarSyncQueue entry = IsarSyncQueue()
      ..sessionId = sessionId
      ..questionId = questionId
      ..selectedOptionOrder = selectedOptionOrder
      ..responseTimeSec = responseTimeSec
      ..createdAt = DateTime.now();
    _db.syncQueue.add(entry);
  }

  Future<int> flush() async {
    final List<IsarSyncQueue> pending =
        _db.syncQueue.where((q) => !q.synced).toList();

    int flushed = 0;
    for (final IsarSyncQueue row in pending) {
      try {
        await _repo.submitAnswer(
          row.sessionId,
          AnswerRequest(
            questionId: row.questionId,
            selectedOptionOrder: row.selectedOptionOrder,
            responseTimeSec: row.responseTimeSec,
          ),
        );
        row.synced = true;
        flushed++;
      } catch (_) {
        break;
      }
    }
    return flushed;
  }
}

@Riverpod(keepAlive: true)
Future<SyncQueueService> syncQueueService(SyncQueueServiceRef ref) async {
  final IsarDb db = await ref.watch(isarDbProvider.future);
  final ExamRepository repo = await ref.watch(examRepositoryProvider.future);
  return SyncQueueService(db, repo);
}
