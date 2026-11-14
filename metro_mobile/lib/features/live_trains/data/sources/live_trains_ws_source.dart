import 'dart:async';
import 'dart:convert';

import 'package:metro_mobile/core/network/backoff.dart';
import 'package:metro_mobile/features/live_trains/data/sources/live_trains_source.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket `/ws/lines/{lineCode}/train-positions` (không cần token). Mỗi
/// gói `{type: "positions", trains: [...]}` là ảnh chụp cả tuyến; backend
/// dùng mã tuyến/mã ga nên được đổi sang id của catalog trước khi trả ra.
class LiveTrainsWsSource implements LiveTrainsSource {
  LiveTrainsWsSource({
    required this.baseUrl,
    required this.catalog,
    WebSocketChannel Function(Uri)? connect,
  }) : _connect = connect ?? WebSocketChannel.connect;

  /// `ws://host:port` (bỏ `/ws` ở cuối nếu có).
  final String baseUrl;
  final Future<NetworkCatalog> Function() catalog;
  final WebSocketChannel Function(Uri) _connect;

  final _connection = StreamController<bool>.broadcast();

  @override
  Stream<bool> get connection => _connection.stream;

  /// `WS_URL` rỗng thì suy ra từ `BASE_URL` (`http` → `ws`).
  static String resolveBase(String wsUrl, String baseUrl) {
    final raw = wsUrl.isNotEmpty
        ? wsUrl
        : baseUrl.replaceFirst(RegExp('^http'), 'ws');
    return raw
        .replaceFirst(RegExp(r'/ws/?$'), '')
        .replaceFirst(RegExp(r'/$'), '');
  }

  @override
  Stream<Object?> subscribe(String lineId) {
    late final StreamController<Object?> ctrl;
    WebSocketChannel? channel;
    var closed = false;
    final wait = Backoff();

    Future<void> run() async {
      final net = await catalog();
      final code = net.line(lineId)?.code;
      if (code == null || baseUrl.isEmpty) return;
      final idOf = {for (final s in net.stations.values) ?s.code: s.id};
      Map<String, Object?> toApp(Map<String, Object?> t) => {
        ...t,
        'lineId': lineId,
        'nextStationId': idOf[t['nextStationId']] ?? t['nextStationId'],
        'headsignStationId':
            idOf[t['headsignStationId']] ?? t['headsignStationId'],
      };
      while (!closed) {
        try {
          final ch = channel = _connect(
            Uri.parse('$baseUrl/ws/lines/$code/train-positions'),
          );
          await ch.ready;
          _connection.add(true);
          wait.reset();
          await for (final msg in ch.stream) {
            final j = jsonDecode('$msg');
            if (j is! Map<String, Object?> || j['type'] != 'positions') {
              continue;
            }
            ctrl.add([
              for (final t in j['trains'] as List? ?? const [])
                toApp((t as Map).cast<String, Object?>()),
            ]);
          }
        } on Object {
          // Mất kết nối: thử lại theo backoff.
        }
        if (closed) break;
        _connection.add(false);
        await Future<void>.delayed(wait.next());
      }
    }

    ctrl = StreamController<Object?>(
      onListen: () => unawaited(run()),
      onCancel: () async {
        closed = true;
        await channel?.sink.close();
      },
    );
    return ctrl.stream;
  }
}
