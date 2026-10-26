import 'dart:async';

import 'package:metro_mobile/features/live_trains/data/sources/live_trains_source.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';

/// Giả lập WebSocket: [trainCount] tàu chạy đi-về trên mỗi tuyến đang
/// khai thác, mỗi [interval] phát một gói/tàu. Đếm subscription đang mở
/// để test không rò rỉ.
class LiveTrainsFakeSource implements LiveTrainsSource {
  LiveTrainsFakeSource({
    required this.catalog,
    this.trainCount = 6,
    this.hopDuration = const Duration(seconds: 60),
    this.interval = const Duration(seconds: 3),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final Future<NetworkCatalog> Function() catalog;
  final int trainCount;
  final Duration hopDuration;

  /// `null` = chỉ phát một lần (dùng trong test, không để lại timer).
  final Duration? interval;
  final DateTime Function() _clock;

  int activeSubscriptions = 0;

  @override
  Stream<bool> get connection => Stream.value(true);

  @override
  Stream<Object?> subscribe(String lineId) {
    Timer? timer;
    late final StreamController<Object?> ctrl;
    ctrl = StreamController<Object?>(
      onListen: () async {
        activeSubscriptions++;
        final c = await catalog();
        final line = c.line(lineId);
        if (line == null || line.isPlanned || ctrl.isClosed) return;
        final stops = c.stationsOf(line);
        void emit() => _snapshot(lineId, stops).forEach(ctrl.add);
        emit();
        final every = interval;
        if (every != null) timer = Timer.periodic(every, (_) => emit());
      },
      onCancel: () {
        activeSubscriptions--;
        timer?.cancel();
        return ctrl.close();
      },
    );
    return ctrl.stream;
  }

  List<Map<String, Object>> _snapshot(String lineId, List<Station> stops) {
    final n = stops.length;
    final loop = 2 * (n - 1);
    final hops = _clock().millisecondsSinceEpoch / hopDuration.inMilliseconds;
    return [
      for (var i = 0; i < trainCount; i++)
        _train(lineId, stops, i, (hops + i * loop / trainCount) % loop),
    ];
  }

  Map<String, Object> _train(String lineId, List<Station> s, int i, double p) {
    final n = s.length;
    final forward = p < n - 1;
    final pos = forward ? p : 2 * (n - 1) - p;
    final a = pos.floor().clamp(0, n - 2);
    final frac = pos - a;
    final to = forward ? s[a + 1] : s[a];
    final k = forward ? frac : 1 - frac;
    return {
      'trainId': '$lineId-T${i + 1}',
      'lineId': lineId,
      'lat': s[a].lat + (s[a + 1].lat - s[a].lat) * frac,
      'lng': s[a].lng + (s[a + 1].lng - s[a].lng) * frac,
      'nextStationId': to.id,
      'etaSec': ((1 - k) * hopDuration.inSeconds).round(),
      'headsignStationId': forward ? s.last.id : s.first.id,
      'status': 'RUNNING',
    };
  }
}
