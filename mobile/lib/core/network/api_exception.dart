sealed class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => '${runtimeType.toString()}: $message';
}

class NetworkException extends ApiException {
  const NetworkException([super.message = 'Bağlantı hatası']);
}

class AuthException extends ApiException {
  const AuthException([super.message = 'Yetkisiz erişim']);
}

class ServerException extends ApiException {
  const ServerException([super.message = 'Sunucu hatası', this.statusCode = 500]);
  final int statusCode;
}

class ValidationException extends ApiException {
  const ValidationException([super.message = 'Geçersiz veri']);
}

class UnknownApiException extends ApiException {
  const UnknownApiException([super.message = 'Bilinmeyen hata']);
}
