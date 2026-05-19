import 'package:dio/dio.dart';

import '../constants/app_endpoints.dart';
import '../storage/secure_token_store.dart';

typedef LogoutCallback = Future<void> Function();

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required SecureTokenStore tokens,
    required Dio refreshClient,
    required LogoutCallback onLogout,
  })  : _tokens = tokens,
        _refreshClient = refreshClient,
        _onLogout = onLogout;

  final SecureTokenStore _tokens;
  final Dio _refreshClient;
  final LogoutCallback _onLogout;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await _tokens.readAccess();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final bool is401 = err.response?.statusCode == 401;
    final bool alreadyRetried = err.requestOptions.extra['retried'] == true;
    final bool isRefreshCall =
        err.requestOptions.path.contains(AppEndpoints.refresh);

    if (!is401 || alreadyRetried || isRefreshCall) {
      handler.next(err);
      return;
    }

    final String? refreshToken = await _tokens.readRefresh();
    if (refreshToken == null) {
      await _onLogout();
      handler.next(err);
      return;
    }

    try {
      final Response<dynamic> resp = await _refreshClient.post(
        AppEndpoints.refresh,
        data: <String, String>{'refreshToken': refreshToken},
      );
      final Map<String, dynamic> data =
          (resp.data['data'] as Map<String, dynamic>);
      final String newAccess = data['accessToken'] as String;
      final String newRefresh = data['refreshToken'] as String;
      await _tokens.save(access: newAccess, refresh: newRefresh);

      final RequestOptions ro = err.requestOptions;
      ro.headers['Authorization'] = 'Bearer $newAccess';
      ro.extra['retried'] = true;

      final Response<dynamic> retry = await _refreshClient.fetch<dynamic>(ro);
      handler.resolve(retry);
    } on DioException {
      await _onLogout();
      handler.next(err);
    }
  }
}
