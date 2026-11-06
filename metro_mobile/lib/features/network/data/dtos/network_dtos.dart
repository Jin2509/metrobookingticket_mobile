import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

typedef Json = Map<String, dynamic>;

double _num(Object? v) => (v as num?)?.toDouble() ?? 0;
int _int(Object? v) => (v as num?)?.round() ?? 0;
String? _text(Object? v) => v is String && v.isNotEmpty ? v : null;

/// JSON ↔ entity cho `/api/v1/lines`, `/api/v1/stations`,
/// `/api/v1/line-transfers` (xem tài liệu nối API Tuyến & Ga).
abstract final class NetworkDtos {
  /// `LineResponse` + `LineStationResponse[]` (đã theo `stationOrder`).
  static MetroLine line(Json j, List<Json> stops) {
    final sorted = [...stops]
      ..sort((a, b) => _int(a['stationOrder']) - _int(b['stationOrder']));
    return MetroLine(
      id: '${j['id']}',
      code: j['code'] as String? ?? '',
      name: j['nameLine'] as String? ?? '',
      colorHex: _text(j['colorHex']) ?? '#576574',
      description: _text(j['description']),
      status: switch (j['status']) {
        'UNDER_CONSTRUCTION' => LineStatus.planned,
        'INACTIVE' => LineStatus.inactive,
        _ => LineStatus.active,
      },
      stationIds: [for (final s in sorted) '${(s['station'] as Json)['id']}'],
      segments: [
        for (final s in sorted)
          LineSegment(
            distanceKm: _num(s['distanceFromPrevKm']),
            travelSeconds: _int(s['travelTimeFromPrevSeconds']),
            dwellSeconds: _int(s['dwellTimeSeconds'] ?? 30),
          ),
      ],
    );
  }

  /// `StationResponse`. [lineIds] ghép từ danh sách ga của các tuyến.
  static Station station(Json j, {List<String> lineIds = const []}) => Station(
    id: '${j['id']}',
    code: _text(j['code']),
    name: j['nameStation'] as String? ?? '',
    lat: _num(j['latitude']),
    lng: _num(j['longitude']),
    lineIds: lineIds,
    address: _text(j['address']),
    district: _text(j['district']),
    imageUrl: _text(j['imageUrl']),
    status: switch (j['status']) {
      'INACTIVE' => StationStatus.inactive,
      'MAINTENANCE' => StationStatus.maintenance,
      _ => StationStatus.active,
    },
  );

  /// `LineTransferResponse`.
  static LineTransfer transfer(Json j) => LineTransfer(
    stationId: '${j['stationId']}',
    fromLineId: '${j['fromLineId']}',
    toLineId: '${j['toLineId']}',
    minutes: _int(j['transferTimeMinutes']),
    active: j['status'] != 'INACTIVE',
  );

  static StationDetail detail(Json station, List<Json> lines) => StationDetail(
    station: NetworkDtos.station(
      station,
      lineIds: [for (final l in lines) '${l['id']}'],
    ),
  );
}
