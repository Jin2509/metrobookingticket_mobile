import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/models/network_diagram_models.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_camera.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_scene.dart';

/// Lớp tàu đang chạy. Khi có vị trí mới, tàu trượt mượt từ chỗ cũ sang chỗ mới
/// bằng hoạt ảnh ngắn nên không có hoạt ảnh lặp vô hạn.
class Network3dTrainLayer extends StatefulWidget {
  const Network3dTrainLayer({
    required this.scene,
    required this.camera,
    required this.trains,
    this.visibleLineIds,
    super.key,
  });

  final Network3dScene scene;
  final Network3dCamera camera;
  final List<DiagramTrain> trains;
  final Set<String>? visibleLineIds;

  @override
  State<Network3dTrainLayer> createState() => _Network3dTrainLayerState();
}

class _Network3dTrainLayerState extends State<Network3dTrainLayer>
    with SingleTickerProviderStateMixin {
  late final _move = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  Map<String, Point3> _from = const {};
  Map<String, Point3> _to = const {};

  @override
  void initState() {
    super.initState();
    _to = _from = _locate();
  }

  @override
  void didUpdateWidget(Network3dTrainLayer old) {
    super.didUpdateWidget(old);
    if (identical(old.trains, widget.trains)) return;
    final next = _locate();
    _from = {for (final id in next.keys) id: _at(id) ?? next[id]!};
    _to = next;
    if (MediaQuery.disableAnimationsOf(context)) {
      _from = next;
    } else {
      _move.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _move.dispose();
    super.dispose();
  }

  Map<String, Point3> _locate() => {
    for (final t in widget.trains)
      if (widget.scene.locateTrain(t.lineId, t.lat, t.lng) case final p?)
        t.id: p,
  };

  Point3? _at(String id) {
    final a = _from[id];
    final b = _to[id];
    if (a == null || b == null) return b;
    final t = Curves.linear.transform(_move.value);
    return Point3(
      a.x + (b.x - a.x) * t,
      a.y + (b.y - a.y) * t,
      a.z + (b.z - a.z) * t,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _move,
      builder: (_, _) => CustomPaint(
        size: Size.infinite,
        painter: _TrainPainter(
          camera: widget.camera,
          trains: [
            for (final t in widget.trains)
              if (widget.visibleLineIds?.contains(t.lineId) ?? true)
                if (_at(t.id) case final p?) (p: p, color: t.color),
          ],
        ),
      ),
    );
  }
}

class _TrainPainter extends CustomPainter {
  const _TrainPainter({required this.camera, required this.trains});

  final Network3dCamera camera;
  final List<({Point3 p, Color color})> trains;

  @override
  void paint(Canvas canvas, Size size) {
    for (final t in trains) {
      final at = camera.project(t.p, size);
      final r = 6.5 * at.scale;
      canvas
        ..drawCircle(
          at.offset,
          r * 2,
          Paint()..color = t.color.withValues(alpha: .35),
        )
        ..drawCircle(at.offset, r, Paint()..color = const Color(0xFFFFFFFF))
        ..drawCircle(at.offset, r * .55, Paint()..color = t.color);
    }
  }

  @override
  bool shouldRepaint(_TrainPainter oldDelegate) => true;
}
