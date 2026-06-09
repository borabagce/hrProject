import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/storage/secure_token_store.dart';
import '../domain/auth_user.dart';
import 'auth_api.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._api, this._tokens);

  final AuthApi _api;
  final SecureTokenStore _tokens;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> resp = await _api.login(<String, dynamic>{
        'email': email,
        'password': password,
      });
      final Map<String, dynamic> data =
          resp['data'] as Map<String, dynamic>;
      final AuthSession session = AuthSession.fromJson(data);
      await _tokens.save(
        access: session.accessToken,
        refresh: session.refreshToken,
      );
      return session;
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }

  Future<AuthUser?> fetchMe() async {
    try {
      final Map<String, dynamic> resp = await _api.me();
      final Object? raw = resp['data'];
      if (raw is! Map<String, dynamic>) return null;
      return AuthUser.fromJson(raw);
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }

  Future<void> updateProfile({required String fullName}) async {
    try {
      await _api.updateProfile(<String, dynamic>{'fullName': fullName});
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _api.changePassword(<String, dynamic>{
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }

  Future<bool> hasStoredSession() async {
    final String? access = await _tokens.readAccess();
    return access != null && access.isNotEmpty;
  }

  Future<void> clearSession() => _tokens.clear();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    ref.watch(authApiProvider),
    ref.watch(secureTokenStoreProvider),
  );
}
