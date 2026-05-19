import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/exam_repository.dart';
import '../domain/test_session.dart';

part 'session_result_provider.g.dart';

@riverpod
Future<SessionResult> sessionResult(SessionResultRef ref, String id) async {
  final ExamRepository repo = await ref.watch(examRepositoryProvider.future);
  return repo.fetchSessionResult(id);
}
