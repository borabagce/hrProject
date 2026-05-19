import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/env.dart';
import '../storage/secure_token_store.dart';
import 'auth_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio create({
    required SecureTokenStore tokens,
    required Future<void> Function() onLogout,
  }) {
    final Dio refreshClient = _baseDio();
    final Dio dio = _baseDio();
    dio.interceptors.add(
      AuthInterceptor(
        tokens: tokens,
        refreshClient: refreshClient,
        onLogout: onLogout,
      ),
    );
    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        responseBody: false,
        responseHeader: false,
        compact: true,
      ),
    );
    return dio;
  }

  static Dio _baseDio() {
    return Dio(
      BaseOptions(
        baseUrl: Env.apiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        contentType: 'application/json',
        responseType: ResponseType.json,
        validateStatus: (int? status) => status != null && status < 500,
      ),
    );
  }
}
