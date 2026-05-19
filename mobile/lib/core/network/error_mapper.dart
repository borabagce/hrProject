import 'package:dio/dio.dart';

import 'api_exception.dart';

ApiException mapDioError(Object error, [StackTrace? _]) {
  if (error is ApiException) return error;
  if (error is! DioException) return const UnknownApiException();

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkException();
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return const UnknownApiException();
    case DioExceptionType.badResponse:
      final int code = error.response?.statusCode ?? 0;
      final String message = _extractMessage(error.response?.data) ?? 'Hata';
      if (code == 401 || code == 403) return AuthException(message);
      if (code == 400 || code == 422) return ValidationException(message);
      return ServerException(message, code);
  }
}

String? _extractMessage(Object? data) {
  if (data is Map<String, dynamic>) {
    final Object? msg = data['message'];
    if (msg is String && msg.isNotEmpty) return msg;
    final Object? errors = data['errors'];
    if (errors is List && errors.isNotEmpty) {
      final Object? first = errors.first;
      if (first is Map && first['msg'] is String) return first['msg'] as String;
    }
  }
  return null;
}
