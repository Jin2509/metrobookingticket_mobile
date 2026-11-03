import 'package:flutter/rendering.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_camera.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_labels.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_layers.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_scene.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_strokes.dart';

/// Vẽ theo thứ tự: phần ngầm, mặt đất, bóng và trụ, phần trên cao, ga, nhãn.
/// Trong mỗi lớp, vật ở xa vẽ trước.
class Network3dPainter extends CustomPainter {
  const Network3dPainter({
    required this.scene,
    required this.camera,
    this.selectedId,
    this.visibleLineIds,
    this.showAllLabels = true,
    this.onStationTap,
  });

  final Network3dScene scene;
  final Network3dCamera camera;
  final String? selectedId;

  /// `null` là hiện mọi tuyến; tuyến ngoài danh sách bị làm mờ.
  final Set<String>? visibleLineIds;
  final bool showAllLabels;
  final void Function(String id)? onStationTap;

  double _opacity(SceneLine l) =>
      visibleLineIds == null || visibleLineIds!.contains(l.data.line.id)
      ? 1
      : .12;

  @override
  void paint(Canvas canvas, Size size) {
    final layers = Network3dLayers(scene, camera, _opacity)
      ..tracks(canvas, size, underground: true);
    paintGround(canvas, size, camera);
    layers
      ..supports(canvas, size)
      ..connectors(canvas, size)
      ..tracks(canvas, size, underground: false);
    _paintStations(canvas, size);
    if (visibleLineIds?.isEmpty ?? false) return;
    paintLabels(canvas, _labels(size));
  }

  List<({SceneNode node, Color color, double opacity, Projected at})> _nodes(
    Size size,
  ) => [
    for (final line in scene.lines)
      for (final node in line.nodes)
        (
          node: node,
          color: line.data.line.color,
          opacity: _opacity(line),
          at: camera.project(node.position, size),
        ),
  ];

  void _paintStations(Canvas canvas, Size size) {
    final nodes = _nodes(size)
      ..sort((a, b) => b.at.depth.compareTo(a.at.depth));
    for (final n in nodes) {
      final selected = n.node.station.id == selectedId;
      paintStation(
        canvas,
        n.at.offset,
        stationRadius(n.node, n.at, selected: selected),
        n.color,
        selected: selected,
        opacity: n.opacity,
      );
    }
  }

  List<({String text, Offset at, bool strong})> _labels(Size size) {
    int rank(SceneNode n) => n.station.id == selectedId
        ? 0
        : n.interchange
        ? 1
        : n.terminus
        ? 2
        : 3;
    final seen = <String>{};
    final nodes = _nodes(size).where((n) => n.opacity == 1).toList()
      ..sort((a, b) {
        final byRank = rank(a.node).compareTo(rank(b.node));
        return byRank != 0 ? byRank : a.at.depth.compareTo(b.at.depth);
      });
    return [
      for (final n in nodes)
        if ((showAllLabels || rank(n.node) < 3) && seen.add(n.node.station.id))
          (
            text: n.node.station.name,
            at: n.at.offset,
            strong: rank(n.node) < 3,
          ),
    ];
  }

  /// Ga gần điểm chạm nhất trong bán kính 28dp.
  String? hitTestStation(Offset point, Size size) {
    String? best;
    var bestDistance = 28.0;
    for (final n in _nodes(size)) {
      if (n.opacity < 1) continue;
      final distance = (n.at.offset - point).distance;
      if (distance < bestDistance) {
        bestDistance = distance;
        best = n.node.station.id;
      }
    }
    return best;
  }

  @override
  SemanticsBuilderCallback? get semanticsBuilder => onStationTap == null
      ? null
      : (size) {
          final seen = <String>{};
          return [
            for (final n in _nodes(size))
              if (seen.add(n.node.station.id))
                CustomPainterSemantics(
                  rect: Rect.fromCircle(center: n.at.offset, radius: 24),
                  properties: SemanticsProperties(
                    label: n.node.station.name,
                    button: true,
                    textDirection: TextDirection.ltr,
                    onTap: () => onStationTap!(n.node.station.id),
                  ),
                ),
          ];
        };

  @override
  bool shouldRepaint(Network3dPainter oldDelegate) =>
      oldDelegate.camera != camera ||
      oldDelegate.scene != scene ||
      oldDelegate.selectedId != selectedId ||
      oldDelegate.visibleLineIds != visibleLineIds;

  @override
  bool shouldRebuildSemantics(Network3dPainter oldDelegate) =>
      shouldRepaint(oldDelegate);
}
