import 'package:metro_mobile/features/live_trains/data/sources/live_trains_source.dart';
import 'package:metro_mobile/features/live_trains/domain/entities/train_position.dart';
import 'package:metro_mobile/features/live_trains/domain/repositories/live_trains_repository.dart';

/// Gộp gói tin từng tàu thành danh sách vị trí mới nhất của tuyến.
class LiveTrainsRepositoryImpl implements LiveTrainsRepository {
  const LiveTrainsRepositoryImpl(this._source);
  final LiveTrainsSource _source;

  @override
  Stream<bool> get connection => _source.connection;

  @override
  Stream<List<TrainPosition>> watchLine(String lineId) {
    final latest = <String, TrainPosition>{};
    return _source.subscribe(lineId).map((payload) {
      final items = payload is List ? payload : [payload];
      for (final item in items.whereType<Map<String, dynamic>>()) {
        final t = _parse(item, lineId);
        if (t != null) latest[t.trainId] = t;
      }
      return latest.values.toList();
    });
  }

  TrainPosition? _parse(Map<String, dynamic> j, String lineId) {
    final lat = j['lat'];
    final lng = j['lng'];
    if (lat is! num || lng is! num || j['trainId'] == null) return null;
    return TrainPosition(
      trainId: '${j['trainId']}',
      lineId: '${j['lineId'] ?? lineId}',
      lat: lat.toDouble(),
      lng: lng.toDouble(),
      nextStationId: '${j['nextStationId']}',
      etaSec: (j['etaSec'] as num?)?.toInt() ?? 0,
      headsignStationId: '${j['headsignStationId'] ?? ''}',
      running: j['status'] != 'STOPPED',
    );
  }
}
