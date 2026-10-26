import 'package:metro_mobile/features/live_trains/domain/entities/train_position.dart';

/// Ước tính tàu sắp đến [stationId] trên tuyến có thứ tự ga [stationIds].
///
/// ETA = `etaSec` tới ga kế + số chặng còn lại × [hopSeconds]. Chỉ tính
/// tàu đang chạy về phía ga. Ở ga đầu/cuối tuyến, tàu đang về sẽ quay
/// đầu nên được tính là chuyến đi chiều ngược lại. Trả tối đa
/// [perDirection] chuyến mỗi hướng.
List<Arrival> estimateArrivals({
  required List<String> stationIds,
  required String stationId,
  required List<TrainPosition> trains,
  int hopSeconds = 120,
  int perDirection = 2,
}) {
  final target = stationIds.indexOf(stationId);
  if (target < 0) return const [];
  final byHeadsign = <String, List<int>>{};
  for (final t in trains) {
    final next = stationIds.indexOf(t.nextStationId);
    final end = stationIds.indexOf(t.headsignStationId);
    if (next < 0 || end < 0 || !t.running) continue;
    final forward = end > next || (end == next && end == stationIds.length - 1);
    final remaining = forward ? target - next : next - target;
    if (remaining < 0) continue;
    final eta = t.etaSec + remaining * hopSeconds;
    final headsign = t.headsignStationId == stationId
        ? (forward ? stationIds.first : stationIds.last)
        : t.headsignStationId;
    (byHeadsign[headsign] ??= []).add(eta);
  }
  return [
    for (final e in byHeadsign.entries)
      Arrival(
        headsignStationId: e.key,
        etaSecs: (e.value..sort()).take(perDirection).toList(),
      ),
  ]..sort((a, b) => a.etaSecs.first.compareTo(b.etaSecs.first));
}
