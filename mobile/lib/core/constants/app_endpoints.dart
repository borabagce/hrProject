class AppEndpoints {
  AppEndpoints._();

  static const String login = '/auth/mobile/login';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';

  static const String myAssignments = '/assignments/me';
  static String startAssignment(String id) => '/assignments/$id/start';
  static String completeAssignment(String id) => '/assignments/$id/complete';

  static const String mySessions = '/sessions/me';
  static String sessionQuestions(String id) => '/sessions/$id/questions';
  static String sessionAnswer(String id) => '/sessions/$id/answer';
  static String sessionResult(String id) => '/sessions/$id/result';

  static const String myAnalytics = '/analytics/me';
  static const String myProfile = '/users/me/profile';
  static const String changePassword = '/users/me/password';
}
