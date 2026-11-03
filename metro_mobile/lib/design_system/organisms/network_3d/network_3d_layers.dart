import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_camera.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_scene.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_strokes.dart';

/// Các lớp đường ray, trụ đỡ và ống nối ga. Trong mỗi lớp, vật ở xa vẽ trước.
class Network3dLayers {
  const Network3dLayers(this.scene, this.camera, this.opacity);

  final Network3dScene scene;
  final Network3dCamera camera;
  final double Function(SceneLine line) opacity;

  double _width(Projected p) => 5.5 * p.scale * math.sqrt(camera.zoom);

  void tracks(Canvas canvas, Size size, {required bool underground}) {
    final segments = [
      for (final line in scene.lines)
        for (var i = 0; i + 1 < line.nodes.length; i++)
          if ((line.nodes[i].position.y + line.nodes[i + 1].position.y < 0) ==
              underground)
            (
              line: line,
              a: camera.project(line.nodes[i].position, size),
              b: camera.project(line.nodes[i + 1].position, size),
            ),
    ]..sort((x, y) => (y.a.depth + y.b.depth).compareTo(x.a.depth + x.b.depth));
    for (final s in segments) {
      final data = s.line.data.line;
      // Phần ngầm nhìn xuyên qua mặt đất nên nhạt hơn.
      final alpha = opacity(s.line) * (underground ? .75 : 1);
      paintTube(
        canvas,
        s.a.offset,
        s.b.offset,
        color: data.color.withValues(alpha: alpha),
        width: _width(s.a),
        dashed: data.planned,
      );
    }
  }

  void supports(Canvas canvas, Size size) {
    for (final line in scene.lines) {
      final alpha = opacity(line);
      for (var i = 0; i < line.nodes.length; i++) {
        final n = line.nodes[i];
        final top = camera.project(n.position, size);
        final foot = camera.project(n.surface, size);
        paintPylon(canvas, top.offset, foot.offset, alpha);
        if (i + 1 == line.nodes.length || n.position.y <= 0) continue;
        final next = line.nodes[i + 1];
        if (next.position.y <= 0 || alpha < 1) continue;
        paintTrackShadow(
          canvas,
          foot,
          camera.project(next.surface, size),
          _width(top),
        );
      }
    }
  }

  void connectors(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xCCFFFFFF)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    for (final points in scene.connectors) {
      for (var i = 0; i + 1 < points.length; i++) {
        canvas.drawLine(
          camera.project(points[i], size).offset,
          camera.project(points[i + 1], size).offset,
          paint,
        );
      }
    }
  }
}
