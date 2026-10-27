import 'package:flutter/rendering.dart';
import 'package:metro_mobile/design_system/organisms/network_diagram/network_layout_types.dart';

/// Vẽ đường tuyến (quy hoạch: nét đứt, nhạt) và nút ga. Ga chuyển tuyến
/// là vòng kép màu [ink], cùng kiểu với `LineDiagram`.
class NetworkDiagramPainter extends CustomPainter {
  const NetworkDiagramPainter({
    required this.layout,
    required this.background,
    required this.ink,
    this.highlightId,
  });

  final NetworkLayout layout;
  final Color background;
  final Color ink;
  final String? highlightId;

  static const stroke = 6.0;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in layout.paths) {
      final paint = Paint()
        ..color = p.line.planned
            ? p.line.color.withValues(alpha: .55)
            : p.line.color
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      for (var i = 0; i + 1 < p.points.length; i++) {
        final a = p.points[i];
        final b = p.points[i + 1];
        p.line.planned
            ? _dashed(canvas, a, b, paint)
            : canvas.drawLine(a, b, paint);
      }
    }
    for (final n in layout.nodes) {
      final color = n.interchange ? ink : n.lines.first.color;
      final ring = Paint()
        ..color = n.planned ? color.withValues(alpha: .55) : color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      final r = n.interchange ? 10.0 : 6.5;
      final fill = n.station.id == highlightId ? color : background;
      canvas
        ..drawCircle(n.pos, r, Paint()..color = fill)
        ..drawCircle(n.pos, r, ring);
      if (n.interchange) {
        canvas.drawCircle(n.pos, r - 5, ring..strokeWidth = 2);
      }
    }
  }

  void _dashed(Canvas canvas, Offset a, Offset b, Paint p) {
    const dash = 7.0;
    final d = b - a;
    final len = d.distance;
    final u = d / len;
    for (var t = 0.0; t < len; t += dash * 2) {
      final end = (t + dash).clamp(0, len).toDouble();
      canvas.drawLine(a + u * t, a + u * end, p);
    }
  }

  @override
  bool shouldRepaint(NetworkDiagramPainter old) =>
      old.layout != layout ||
      old.background != background ||
      old.ink != ink ||
      old.highlightId != highlightId;
}
