import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:metro_mobile/design_system/models/map_models.dart';
import 'package:metro_mobile/design_system/organisms/metro_map/bus_stop_layer.dart';
import 'package:metro_mobile/design_system/organisms/metro_map/line_polyline_layer.dart';
import 'package:metro_mobile/design_system/organisms/metro_map/live_train_layer.dart';
import 'package:metro_mobile/design_system/organisms/metro_map/osm_attribution.dart';
import 'package:metro_mobile/design_system/organisms/metro_map/osm_tile_layer.dart';
import 'package:metro_mobile/design_system/organisms/metro_map/station_marker_layer.dart';
import 'package:metro_mobile/design_system/organisms/metro_map/user_location_layer.dart';

/// Bản đồ mạng lưới bằng `flutter_map` (Leaflet) + tile OSM (D2).
class MetroMapView extends StatelessWidget {
  const MetroMapView({
    required this.lines,
    required this.stations,
    this.busStops = const [],
    this.trains = const [],
    this.overlays = const [],
    this.userLocation,
    this.highlightedStationId,
    this.controller,
    this.showTiles = true,
    this.onStationTap,
    this.onMapTap,
    super.key,
  });

  /// Trung tâm TP.HCM, thấy trọn Tuyến 1.
  static const defaultCenter = LatLng(10.8100, 106.7400);

  final List<MapLineData> lines;
  final List<MapStationData> stations;
  final List<MapBusStopData> busStops;
  final List<MapTrainData> trains;

  /// Lớp vẽ thêm phía trên (VD lớp tàu realtime tự rebuild riêng để
  /// không dựng lại marker ga mỗi giây).
  final List<Widget> overlays;
  final LatLng? userLocation;
  final String? highlightedStationId;
  final MapController? controller;
  final bool showTiles;
  final ValueChanged<String>? onStationTap;
  final ValueChanged<LatLng>? onMapTap;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: defaultCenter,
        initialZoom: 12,
        minZoom: 10,
        maxZoom: 18,
        onTap: onMapTap == null ? null : (_, p) => onMapTap!(p),
      ),
      children: [
        if (showTiles) const OsmTileLayer(),
        LinePolylineLayer(lines: lines),
        BusStopLayer(stops: busStops),
        StationMarkerLayer(
          stations: stations,
          highlightedId: highlightedStationId,
          onTap: onStationTap,
        ),
        if (trains.isNotEmpty) LiveTrainLayer(trains: trains),
        ...overlays,
        if (userLocation != null) UserLocationLayer(point: userLocation!),
        if (showTiles) const OsmAttribution(),
      ],
    );
  }
}
