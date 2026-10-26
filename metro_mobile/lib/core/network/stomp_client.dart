import 'dart:async';
import 'dart:convert';

import 'package:metro_mobile/core/network/backoff.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

/// Bọc STOMP `/ws`. Chỉ kết nối khi có ít nhất một topic đang được nghe,
/// tự hủy subscribe khi không còn ai nghe. Mất kết nối thì thử lại theo
/// `Backoff` và subscribe lại các topic đang mở.
class MetroStompClient {
  MetroStompClient({
    required String url,
    required Future<String?> Function() token,
    Backoff? backoff,
  }) : _url = url,
       _token = token,
       _backoff = backoff ?? Backoff();

  final String _url;
  final Future<String?> Function() _token;
  final Backoff _backoff;

  final _topics = <String, StreamController<Object?>>{};
  final _unsubs = <String, StompUnsubscribe>{};
  final _connection = StreamController<bool>.broadcast();
  StompClient? _client;
  Timer? _retry;
  bool _connected = false;

  /// `true` = đã kết nối, `false` = đang kết nối lại.
  Stream<bool> get connection => _connection.stream;

  /// Payload JSON đã giải mã của [topic].
  Stream<Object?> subscribe(String topic) {
    final ctrl = _topics.putIfAbsent(
      topic,
      () => StreamController<Object?>.broadcast(
        onListen: () {
          if (_connected) _subscribe(topic);
          unawaited(_activate());
        },
        onCancel: () {
          _unsubs.remove(topic)?.call();
          unawaited(_topics.remove(topic)?.close());
          if (_topics.isEmpty) _shutdown();
        },
      ),
    );
    return ctrl.stream;
  }

  Future<void> _activate() async {
    if (_client != null || _topics.isEmpty) return;
    final token = await _token();
    _client = StompClient(
      config: StompConfig(
        url: _url,
        reconnectDelay: Duration.zero,
        stompConnectHeaders: {'Authorization': ?_bearer(token)},
        onConnect: (_) => _onConnect(),
        onWebSocketError: (_) => _onDrop(),
        onStompError: (_) => _onDrop(),
        onWebSocketDone: _onDrop,
      ),
    )..activate();
  }

  String? _bearer(String? token) => token == null ? null : 'Bearer $token';

  void _onConnect() {
    _connected = true;
    _backoff.reset();
    _connection.add(true);
    _topics.keys.forEach(_subscribe);
  }

  void _onDrop() {
    if (_topics.isEmpty) return;
    _connected = false;
    _connection.add(false);
    _unsubs.clear();
    _client?.deactivate();
    _client = null;
    _retry?.cancel();
    _retry = Timer(_backoff.next(), () => unawaited(_activate()));
  }

  void _subscribe(String topic) {
    _unsubs[topic] = _client!.subscribe(
      destination: topic,
      callback: (frame) {
        final body = frame.body;
        if (body != null) _topics[topic]?.add(jsonDecode(body));
      },
    );
  }

  void _shutdown() {
    _retry?.cancel();
    _client?.deactivate();
    _client = null;
    _connected = false;
  }
}
