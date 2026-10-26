import 'package:flutter/foundation.dart';

/// Gói tin `/topic/trains/{lineId}` (mục 9), thêm `headsignStationId`
/// (ga cuối theo hướng chạy) để ước tính giờ đến từng ga.
@immutable
class TrainPosition {
  const TrainPosition({
    required this.trainId,
    required this.lineId,
    required this.lat,
    required this.lng,
    required this.nextStationId,
    required this.etaSec,
    required this.headsignStationId,
    this.running = true,
  });

  final String trainId;
  final String lineId;
  final double lat;
  final double lng;
  final String nextStationId;

  /// Số giây tới [nextStationId].
  final int etaSec;
  final String headsignStationId;
  final bool running;

  TrainPosition moveTo(double lat, double lng) => TrainPosition(
    trainId: trainId,
    lineId: lineId,
    lat: lat,
    lng: lng,
    nextStationId: nextStationId,
    etaSec: etaSec,
    headsignStationId: headsignStationId,
    running: running,
  );
}

/// Tàu sắp đến một ga theo một hướng: `→ Suối Tiên  2 ph · 10 ph`.
@immutable
class Arrival {
  const Arrival({required this.headsignStationId, required this.etaSecs});

  final String headsignStationId;
  final List<int> etaSecs;
}
