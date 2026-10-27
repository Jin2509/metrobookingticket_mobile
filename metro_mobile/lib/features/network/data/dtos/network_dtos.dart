import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

typedef Json = Map<String, dynamic>;

List<String> _strings(Object? v) => [for (final e in v as List? ?? []) '$e'];

/// JSON ↔ entity cho `/api/routes`, `/api/stations`, `/api/routes/search`.
abstract final class NetworkDtos {
  static MetroLine line(Json j) => MetroLine(
    id: '${j['id']}',
    code: j['code'] as String? ?? '',
    name: j['name'] as String? ?? '',
    colorHex: j['colorHex'] as String? ?? '#576574',
    status: j['status'] == 'PLANNED' ? LineStatus.planned : LineStatus.active,
    stationIds: _strings(j['stationIds']),
    lengthKm: (j['lengthKm'] as num?)?.toDouble(),
    operatingHours: j['operatingHours'] as String?,
    headway: j['headway'] as String?,
  );

  static Station station(Json j) => Station(
    id: '${j['id']}',
    name: j['name'] as String? ?? '',
    lat: (j['lat'] as num).toDouble(),
    lng: (j['lng'] as num).toDouble(),
    lineIds: _strings(j['lineIds']),
    address: j['address'] as String?,
    active: j['status'] != 'INACTIVE',
    structure: switch (j['structure']) {
      'UNDERGROUND' => StationStructure.underground,
      'AT_GRADE' => StationStructure.atGrade,
      _ => StationStructure.elevated,
    },
  );

  static BusStop busStop(Json j) => BusStop(
    id: '${j['id']}',
    name: j['name'] as String? ?? '',
    lat: (j['lat'] as num).toDouble(),
    lng: (j['lng'] as num).toDouble(),
    walkMinutes: j['walkMinutes'] as int? ?? 0,
    routes: _strings(j['routes']),
  );

  static Amenity amenity(Json j) => Amenity(
    name: j['name'] as String? ?? '',
    kind: AmenityKind.values.firstWhere(
      (k) => k.name.toUpperCase() == j['kind'],
      orElse: () => AmenityKind.landmark,
    ),
    distanceM: j['distanceM'] as int? ?? 0,
    address: j['address'] as String?,
  );

  static StationDetail detail(Json j) => StationDetail(
    station: station(j['station'] as Json),
    amenities: [
      for (final a in j['amenities'] as List? ?? []) amenity(a as Json),
    ],
    busStops: [
      for (final b in j['busStops'] as List? ?? []) busStop(b as Json),
    ],
    exits: _strings(j['exits']),
  );

  static NearbyStation nearby(Json j) => NearbyStation(
    station: station(j['station'] as Json),
    distanceM: (j['distanceM'] as num).toDouble(),
  );

  static RoutePlan plan(Json j) => RoutePlan(
    legs: [
      for (final l in j['legs'] as List? ?? [])
        RouteLeg(
          lineId: '${(l as Json)['lineId']}',
          stationIds: _strings(l['stationIds']),
        ),
    ],
    minutes: j['minutes'] as int? ?? 0,
    fare: j['fare'] as int? ?? 0,
  );
}
