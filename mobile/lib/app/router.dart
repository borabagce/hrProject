import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/providers/auth_notifier.dart';
import '../features/exams/presentation/screens/exam_result_screen.dart';
import '../features/exams/presentation/screens/exam_screen.dart';
import '../features/exams/presentation/screens/tests_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/results/presentation/screens/analytics_screen.dart';
import 'main_scaffold.dart';

class AppRoutes {
  AppRoutes._();
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String tests = '/tests';
  static const String analytics = '/analytics';
  static const String profile = '/profile';
  static const String exam = '/exam';
  static const String examResult = '/result';
}

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) => _createRouter(ref));

GoRouter _createRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: _AuthChangeNotifier(ref),
    redirect: (BuildContext context, GoRouterState state) {
      final AsyncValue<AuthState> auth = ref.read(authNotifierProvider);
      final String loc = state.matchedLocation;
      final bool atSplash = loc == AppRoutes.splash;
      final bool atLogin = loc == AppRoutes.login;

      if (auth.isLoading || !auth.hasValue) return null;

      final AuthState authValue = auth.requireValue;
      final bool isAuthed = authValue is AuthAuthenticated;

      if (atSplash) {
        return isAuthed ? AppRoutes.home : AppRoutes.login;
      }
      if (!isAuthed && !atLogin) return AppRoutes.login;
      if (isAuthed && atLogin) return AppRoutes.home;
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (BuildContext c, GoRouterState s) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext c, GoRouterState s) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (BuildContext c, GoRouterState s, Widget child) =>
            MainScaffold(child: child),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (BuildContext c, GoRouterState s) =>
                const NoTransitionPage<void>(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.tests,
            pageBuilder: (BuildContext c, GoRouterState s) =>
                const NoTransitionPage<void>(child: TestsScreen()),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            pageBuilder: (BuildContext c, GoRouterState s) =>
                const NoTransitionPage<void>(child: AnalyticsScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (BuildContext c, GoRouterState s) =>
                const NoTransitionPage<void>(child: ProfileScreen()),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '${AppRoutes.exam}/:sessionId',
        builder: (BuildContext c, GoRouterState s) {
          final String sessionId = s.pathParameters['sessionId']!;
          final String? assignmentId = s.uri.queryParameters['assignmentId'];
          return ExamScreen(
            sessionId: sessionId,
            assignmentId: assignmentId,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '${AppRoutes.examResult}/:sessionId',
        builder: (BuildContext c, GoRouterState s) {
          final String sessionId = s.pathParameters['sessionId']!;
          return ExamResultScreen(sessionId: sessionId);
        },
      ),
    ],
  );
}

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(this._ref) {
    _ref.listen<AsyncValue<AuthState>>(
      authNotifierProvider,
      (AsyncValue<AuthState>? prev, AsyncValue<AuthState> next) {
        notifyListeners();
      },
    );
  }
  final Ref _ref;
}
