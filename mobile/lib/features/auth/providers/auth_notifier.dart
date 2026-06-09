import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';
import '../domain/auth_user.dart';

part 'auth_notifier.g.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.errorMessage});
  final String? errorMessage;
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final AuthUser user;
}

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<AuthState> build() async {
    final AuthRepository repo = ref.watch(authRepositoryProvider);
    if (!await repo.hasStoredSession()) {
      return const AuthUnauthenticated();
    }
    try {
      final AuthUser? user = await repo.fetchMe();
      if (user == null) {
        await repo.clearSession();
        return const AuthUnauthenticated();
      }
      return AuthAuthenticated(user);
    } catch (_) {
      await repo.clearSession();
      return const AuthUnauthenticated();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue<AuthState>.data(AuthLoading());
    state = await AsyncValue.guard(() async {
      final AuthRepository repo = ref.read(authRepositoryProvider);
      final AuthSession session =
          await repo.login(email: email, password: password);
      return AuthAuthenticated(session.user);
    });
    if (state.hasError) {
      final String msg = state.error.toString();
      state = AsyncValue<AuthState>.data(
        AuthUnauthenticated(errorMessage: msg),
      );
    }
  }

  Future<void> logout() async {
    final AuthRepository repo = ref.read(authRepositoryProvider);
    await repo.clearSession();
    state = const AsyncValue<AuthState>.data(AuthUnauthenticated());
  }

  Future<void> updateFullName(String fullName) async {
    final AuthRepository repo = ref.read(authRepositoryProvider);
    await repo.updateProfile(fullName: fullName);
    final AuthUser? user = await repo.fetchMe();
    if (user != null) {
      state = AsyncValue<AuthState>.data(AuthAuthenticated(user));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final AuthRepository repo = ref.read(authRepositoryProvider);
    await repo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> forceLogout() async {
    final AuthRepository repo = ref.read(authRepositoryProvider);
    await repo.clearSession();
    state = const AsyncValue<AuthState>.data(AuthUnauthenticated());
  }
}
