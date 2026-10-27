import 'package:flutter/foundation.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';

/// Loại tiện ích quanh ga (`amenity.kind`, viết HOA trong JSON).
enum AmenityKind {
  hospital,
  market,
  shop,
  food,
  school,
  park,
  landmark,
  atm,
  parking,
  toilet,
}

@immutable
class Amenity {
  const Amenity({
    required this.name,
    required this.kind,
    required this.distanceM,
    this.address,
  });

  final String name;
  final AmenityKind kind;
  final int distanceM;
  final String? address;

  /// Đi bộ ~75 m/phút, tối thiểu 1 phút.
  int get walkMinutes => (distanceM / 75).ceil().clamp(1, 999);
}

/// Trạm xe buýt quanh ga (UC6).
@immutable
class BusStop {
  const BusStop({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.walkMinutes,
    required this.routes,
  });

  final String id;
  final String name;
  final double lat;
  final double lng;
  final int walkMinutes;

  /// Số hiệu tuyến buýt, VD `['01', '03', '19']`.
  final List<String> routes;
}

@immutable
class StationDetail {
  const StationDetail({
    required this.station,
    this.amenities = const [],
    this.busStops = const [],
    this.exits = const [],
  });

  final Station station;
  final List<Amenity> amenities;
  final List<BusStop> busStops;

  /// Lối ra, VD `Cửa 1 – Chợ Bến Thành`.
  final List<String> exits;
}

@immutable
class NearbyStation {
  const NearbyStation({required this.station, required this.distanceM});

  final Station station;
  final double distanceM;
}
