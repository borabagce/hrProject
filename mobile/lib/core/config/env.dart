import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();

  static const String _kApiUrl = 'API_URL';
  static const String _kNtfyUrl = 'NTFY_URL';
  static const String _kNtfyTopic = 'NTFY_TOPIC';

  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get apiUrl =>
      const String.fromEnvironment(_kApiUrl, defaultValue: '').isNotEmpty
          ? const String.fromEnvironment(_kApiUrl)
          : (dotenv.maybeGet(_kApiUrl) ?? 'http://hrproject-production.up.railway.app:8080/api');

  static String? get ntfyUrl =>
      const String.fromEnvironment(_kNtfyUrl, defaultValue: '').isNotEmpty
          ? const String.fromEnvironment(_kNtfyUrl)
          : dotenv.maybeGet(_kNtfyUrl);

  static String? get ntfyTopic =>
      const String.fromEnvironment(_kNtfyTopic, defaultValue: '').isNotEmpty
          ? const String.fromEnvironment(_kNtfyTopic)
          : dotenv.maybeGet(_kNtfyTopic);
}
