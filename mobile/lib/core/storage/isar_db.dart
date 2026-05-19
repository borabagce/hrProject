import 'isar_models.dart';

class IsarDb {
  IsarDb._();

  static Future<IsarDb> open() async => IsarDb._();

  final Map<String, IsarAssignment> assignments = {};
  final Map<String, IsarQuestion> questions = {};
  final Map<String, IsarSessionResult> sessionResults = {};
  final List<IsarSyncQueue> syncQueue = [];
  IsarUserProfile? userProfile;

  Future<void> clear() async {
    assignments.clear();
    questions.clear();
    sessionResults.clear();
    syncQueue.clear();
    userProfile = null;
  }
}
