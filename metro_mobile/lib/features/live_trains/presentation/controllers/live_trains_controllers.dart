import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/live_trains/domain/entities/train_position.dart';
import 'package:metro_mobile/features/live_trains/domain/usecases/interpolate_trains.dart';
import 'package:metro_mobile/features/live_trains/live_trains_providers.dart';

/// Vị trí thô của tuyến. `autoDispose`: rời màn là hủy subscribe topic.
final lineTrainsProvider = StreamProvider.autoDispose
    .family<List<TrainPosition>, String>(
      (ref, lineId) =>
          ref.watch(liveTrainsRepositoryProvider).watchLine(lineId),
    );

/// `false` khi đang kết nối lại → chip "Đang kết nối lại…".
final liveConnectionProvider = StreamProvider.autoDispose<bool>(
  (ref) => ref.watch(liveTrainsRepositoryProvider).connection,
);

final animatedTrainsProvider = NotifierProvider.autoDispose
    .family<AnimatedTrains, List<TrainPosition>, String>(AnimatedTrains.new);

/// Nội suy marker 1s/lần giữa gói trước và gói mới nhất, thay vì vẽ lại
/// theo từng gói tin (mục 9: tối ưu cho mạng lưới nhiều ga).
class AnimatedTrains extends Notifier<List<TrainPosition>> {
  AnimatedTrains(this.lineId);
  final String lineId;

  static const packetInterval = Duration(seconds: 3);
  static const tick = Duration(seconds: 1);

  List<TrainPosition> _from = const [];
  List<TrainPosition> _to = const [];
  DateTime _receivedAt = DateTime.now();

  @override
  List<TrainPosition> build() {
    final timer = Timer.periodic(tick, (_) => _step());
    ref
      ..onDispose(timer.cancel)
      ..listen(lineTrainsProvider(lineId), (_, next) {
        final trains = next.value;
        if (trains == null) return;
        _from = _to.isEmpty ? trains : state;
        _to = trains;
        _receivedAt = DateTime.now();
        _step();
      });
    // Luồng đã có dữ liệu (VD Trang chủ vừa nghe) → hiện tàu ngay, không
    // chờ gói tin kế tiếp.
    final current = ref.read(lineTrainsProvider(lineId)).value;
    if (current == null) return const [];
    _from = _to = current;
    _receivedAt = DateTime.now();
    return current;
  }

  void _step() {
    final elapsed = DateTime.now().difference(_receivedAt).inMilliseconds;
    state = interpolateTrains(
      _from,
      _to,
      elapsed / packetInterval.inMilliseconds,
    );
  }
}
