import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'notification_service.dart';

class NtfyListener {
  NtfyListener({
    required this.ntfyUrl,
    required this.topic,
    required NotificationService notifications,
  }) : _notifications = notifications;

  final String ntfyUrl;
  final String topic;
  final NotificationService _notifications;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;

  void start() {
    if (ntfyUrl.isEmpty || topic.isEmpty) return;
    final Uri uri = Uri.parse('$ntfyUrl/$topic/ws');
    _channel = WebSocketChannel.connect(uri);
    _sub = _channel!.stream.listen(
      _onMessage,
      onError: (_) => _reconnect(),
      onDone: _reconnect,
      cancelOnError: true,
    );
  }

  Future<void> _onMessage(dynamic raw) async {
    try {
      final Map<String, dynamic> data =
          jsonDecode(raw.toString()) as Map<String, dynamic>;
      if (data['event'] != 'message') return;
      final String title = (data['title'] as String?) ?? 'Yeni bildirim';
      final String body = (data['message'] as String?) ?? '';
      await _notifications.show(title: title, body: body);
    } catch (_) {
      // ignore malformed messages
    }
  }

  void _reconnect() {
    stop();
    Future<void>.delayed(const Duration(seconds: 5), start);
  }

  void stop() {
    _sub?.cancel();
    _channel?.sink.close();
    _sub = null;
    _channel = null;
  }
}
