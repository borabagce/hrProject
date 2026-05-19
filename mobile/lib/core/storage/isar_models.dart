class IsarUserProfile {
  String userId = '';
  String fullName = '';
  String email = '';
  String? departmentId;
  String? companyId;
  DateTime updatedAt = DateTime.now();
}

class IsarAssignment {
  String assignmentId = '';
  String status = '';
  String? testId;
  String? testTitle;
  int? difficulty;
  DateTime? dueDate;
  DateTime? completedAt;
  String? sessionId;
  DateTime cachedAt = DateTime.now();
}

class IsarQuestion {
  String questionId = '';
  String sessionId = '';
  String text = '';
  String type = '';
  int difficulty = 1;
  List<String> optionTexts = [];
  List<int> optionOrders = [];
  DateTime cachedAt = DateTime.now();
}

class IsarSessionResult {
  String sessionId = '';
  int scorePercent = 0;
  int correctCount = 0;
  int totalQuestions = 0;
  DateTime? completedAt;
  DateTime cachedAt = DateTime.now();
}

class IsarSyncQueue {
  String sessionId = '';
  String questionId = '';
  int selectedOptionOrder = 0;
  double? responseTimeSec;
  DateTime createdAt = DateTime.now();
  bool synced = false;
}
