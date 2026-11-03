import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:metro_mobile/design_system/models/network_diagram_models.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_camera.dart';

/// Ga của một tuyến trong không gian 3D.
@immutable
class SceneNode {
  const SceneNode({
    required this.station,
    required this.position,
    required this.surface,
    required this.interchange,
    required this.terminus,
  });

  final DiagramStationData station;
  final Point3 position;

  /// Chân thẳng đứng của ga trên mặt đất.
  final Point3 surface;
  final bool interchange;
  final bool terminus;
}

@immutable
class SceneLine {
  const SceneLine(this.data, this.nodes);

  final NetworkDiagramLine data;
  final List<SceneNode> nodes;
}

/// Dựng sơ đồ từ tọa độ thật. Mỗi tuyến một tầng độ cao riêng nên hai tuyến đi
/// qua cùng ga vẫn tách nhau và nối bằng ống dọc.
@immutable
class Network3dScene {
  const Network3dScene._(this.lines, this.connectors, [this._toScene]);

  factory Network3dScene.from(List<NetworkDiagramLine> lines) {
    final stations = [for (final l in lines) ...l.stations];
    if (stations.isEmpty) return const Network3dScene._([], []);
    final lats = stations.map((s) => s.lat);
    final lngs = stations.map((s) => s.lng);
    final minLat = lats.reduce(math.min);
    final maxLat = lats.reduce(math.max);
    final minLng = lngs.reduce(math.min);
    final maxLng = lngs.reduce(math.max);
    final midLat = (minLat + maxLat) / 2;
    final midLng = (minLng + maxLng) / 2;
    // Một độ kinh tuyến ngắn hơn một độ vĩ tuyến theo cos(vĩ độ).
    final lngScale = math.cos(midLat * math.pi / 180);
    final extent = math
        .max((maxLng - minLng) * lngScale, maxLat - minLat)
        .clamp(1e-6, double.infinity);

    final count = <String, int>{};
    for (final s in stations) {
      count[s.id] = (count[s.id] ?? 0) + 1;
    }
    final built = <SceneLine>[];
    final byStation = <String, List<Point3>>{};
    for (final (index, line) in lines.indexed) {
      final last = line.stations.length - 1;
      final nodes = <SceneNode>[];
      for (final (i, s) in line.stations.indexed) {
        final x = (s.lng - midLng) * lngScale / extent * 2;
        final z = -(s.lat - midLat) / extent * 2;
        final level = _baseLevel + _lineGap * index;
        final position = Point3(x, s.underground ? -level : level, z);
        byStation.putIfAbsent(s.id, () => []).add(position);
        nodes.add(
          SceneNode(
            station: s,
            position: position,
            surface: Point3(x, 0, z),
            interchange: count[s.id]! > 1,
            terminus: i == 0 || i == last,
          ),
        );
      }
      built.add(SceneLine(line, nodes));
    }
    return Network3dScene._(
      built,
      [
        for (final points in byStation.values)
          if (points.length > 1) points,
      ],
      (lat, lng) => (
        (lng - midLng) * lngScale / extent * 2,
        -(lat - midLat) / extent * 2,
      ),
    );
  }

  static const _baseLevel = .1;
  static const _lineGap = .09;

  final List<SceneLine> lines;

  /// Các điểm của cùng một ga trên nhiều tuyến.
  final List<List<Point3>> connectors;

  final (double, double) Function(double lat, double lng)? _toScene;

  /// Vị trí tàu trong không gian: chiếu lên đoạn ray gần nhất của tuyến để tàu
  /// nằm đúng trên ray và đúng độ cao, kể cả khi đang chuyển từ ngầm lên cao.
  /// Tuyến không có trên sơ đồ thì trả `null`.
  Point3? locateTrain(String lineId, double lat, double lng) {
    final toScene = _toScene;
    final line = lines.where((l) => l.data.line.id == lineId).firstOrNull;
    if (toScene == null || line == null || line.nodes.length < 2) return null;
    final (x, z) = toScene(lat, lng);
    Point3? best;
    var bestDistance = double.infinity;
    for (var i = 0; i + 1 < line.nodes.length; i++) {
      final a = line.nodes[i].position;
      final b = line.nodes[i + 1].position;
      final dx = b.x - a.x;
      final dz = b.z - a.z;
      final length = dx * dx + dz * dz;
      final t = length == 0
          ? 0.0
          : (((x - a.x) * dx + (z - a.z) * dz) / length).clamp(0.0, 1.0);
      final px = a.x + dx * t;
      final pz = a.z + dz * t;
      final distance = (x - px) * (x - px) + (z - pz) * (z - pz);
      if (distance < bestDistance) {
        bestDistance = distance;
        best = Point3(px, a.y + (b.y - a.y) * t, pz);
      }
    }
    return best;
  }
}
