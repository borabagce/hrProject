import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/exam_repository.dart';
import '../domain/assignment.dart';

part 'assignments_provider.g.dart';

@riverpod
Future<List<Assignment>> assignments(
  AssignmentsRef ref, {
  String? status,
}) async {
  final ExamRepository repo = await ref.watch(examRepositoryProvider.future);
  return repo.fetchAssignments(status: status);
}
