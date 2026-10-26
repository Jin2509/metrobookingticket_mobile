import 'package:metro_mobile/features/live_trains/domain/entities/train_position.dart';

/// Nội suy tuyến tính vị trí tàu giữa gói trước và gói mới nhất
/// (t = 0 → [from], t = 1 → [to]) để marker chạy mượt 1s/lần.
List<TrainPosition> interpolateTrains(
  List<TrainPosition> from,
  List<TrainPosition> to,
  double t,
) {
  final k = t.clamp(0.0, 1.0);
  final prev = {for (final p in from) p.trainId: p};
  return [
    for (final next in to)
      switch (prev[next.trainId]) {
        null => next,
        final p => next.moveTo(
          p.lat + (next.lat - p.lat) * k,
          p.lng + (next.lng - p.lng) * k,
        ),
      },
  ];
}
