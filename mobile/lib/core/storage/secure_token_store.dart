import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStore {
  SecureTokenStore(this._storage);

  static const String _kAccess = 'access_token';
  static const String _kRefresh = 'refresh_token';

  final FlutterSecureStorage _storage;

  Future<void> save({required String access, required String refresh}) async {
    await Future.wait<void>([
      _storage.write(key: _kAccess, value: access),
      _storage.write(key: _kRefresh, value: refresh),
    ]);
  }

  Future<String?> readAccess() => _storage.read(key: _kAccess);
  Future<String?> readRefresh() => _storage.read(key: _kRefresh);

  Future<void> updateAccess(String token) =>
      _storage.write(key: _kAccess, value: token);

  Future<void> clear() => _storage.deleteAll();
}
