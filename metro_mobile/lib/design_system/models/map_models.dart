import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:latlong2/latlong.dart';

export 'package:latlong2/latlong.dart' show LatLng;

/// Dữ liệu hiển thị cho `MetroMapView`. Feature map entity sang đây.
@immutable
class MapLineData {
  const MapLineData({
    required this.id,
    required this.color,
    required this.points,
    this.planned = false,
  });

  final String id;
  final Color color;
  final List<LatLng> points;
  final bool planned;
}

@immutable
class MapStationData {
  const MapStationData({
    required this.id,
    required this.name,
    required this.point,
    required this.color,
    this.interchange = false,
    this.active = true,
  });

  final String id;
  final String name;
  final LatLng point;
  final Color color;
  final bool interchange;
  final bool active;
}

@immutable
class MapBusStopData {
  const MapBusStopData({
    required this.id,
    required this.name,
    required this.point,
  });

  final String id;
  final String name;
  final LatLng point;
}

@immutable
class MapTrainData {
  const MapTrainData({
    required this.id,
    required this.point,
    required this.color,
  });

  final String id;
  final LatLng point;
  final Color color;
}
