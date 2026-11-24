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

  static StationDetail detail(
    Json station,
    List<Json> lines, {
    List<Json> bus = const [],
    List<Json> facilities = const [],
  }) => StationDetail(
    station: NetworkDtos.station(
      station,
      lineIds: [for (final l in lines) '${l['id']}'],
    ),
    busStops: busStops(bus),
    amenities: [for (final f in facilities) ?amenity(f)],
  );

  /// `BusStopDto[]` (`/stations/{id}/bus`). Một trạm có thể lặp lại theo từng
  /// tuyến và `routeCode` có thể là danh sách "01,03": gộp theo `stopId`.
  static List<BusStop> busStops(List<Json> rows) {
    // Map của Dart giữ thứ tự chèn: trạm gần nhất (backend đã sắp) đứng trước.
    final first = <String, Json>{};
    final routes = <String, Set<String>>{};
    for (final j in rows) {
      final id = _text(j['stopId']) ?? _text(j['name']);
      if (id == null) continue;
      first.putIfAbsent(id, () => j);
      (routes[id] ??= {}).addAll([
        for (final c in '${j['routeCode'] ?? ''}'.split(','))
          if (c.trim().isNotEmpty) c.trim(),
      ]);
    }
    return [
      for (final MapEntry(key: id, value: j) in first.entries)
        BusStop(
          id: id,
          name: _text(j['name']) ?? id,
          lat: _num(j['latitude']),
          lng: _num(j['longitude']),
          walkMinutes: _walkMinutes(j['distanceMeters']),
          routes: routes[id]!.toList(),
        ),
    ];
  }

  /// `FacilityDto` (`/stations/{id}/facilities`). Bỏ `TRANSPORT`: nhóm này
  /// gộp cả trạm buýt lẫn bãi xe nên không gán được một loại, còn trạm buýt
  /// đã có từ API buýt.
  static Amenity? amenity(Json j) {
    final kind = switch (j['category']) {
      'FOOD' => AmenityKind.food,
      'HEALTH' => AmenityKind.hospital,
      'EDUCATION' => AmenityKind.school,
      'SHOP' => AmenityKind.shop,
      'PARK' => AmenityKind.park,
      'BANK' => AmenityKind.atm,
      'TRANSPORT' => null,
      _ => AmenityKind.landmark,
    };
    final name = _text(j['name']);
    if (kind == null || name == null) return null;
    return Amenity(
      name: name,
      kind: kind,
      distanceM: _int(j['distanceMeters']),
      address: _text(j['address']),
    );
  }

  /// Đi bộ ~75 m/phút, như `Amenity.walkMinutes`.
  static int _walkMinutes(Object? meters) =>
      (_num(meters) / 75).ceil().clamp(1, 999);
}
