import 'package:flutter/rendering.dart';

/// Vẽ cột bên trái của một dòng: đoạn trên, đoạn dưới và nút ga.
/// Ga chuyển tuyến là vòng kép; [filled] tô đặc nút (ga đi/đến).
class LineDiagramPainter extends CustomPainter {
  const LineDiagramPainter({
    required this.above,
    required this.below,
    required this.node,
    required this.background,
    this.interchange = false,
    this.filled = false,
    this.dashedAbove = false,
    this.dashedBelow = false,
  });

  final Color? above;
  final Color? below;

  /// `null` = dòng rút gọn, không vẽ nút.
  final Color? node;
  final Color background;
  final bool interchange;
  final bool filled;
  final bool dashedAbove;
  final bool dashedBelow;

  static const stroke = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 2;
    final y = size.height / 2;
    if (above != null) {
      _segment(canvas, Offset(x, 0), Offset(x, y), above!, dashedAbove);
    }
    if (below != null) {
      _segment(
        canvas,
        Offset(x, y),
        Offset(x, size.height),
        below!,
        dashedBelow,
      );
    }
    final c = node;
    if (c == null) return;
    final ring = Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final r = interchange ? 9.0 : 7.0;
    canvas
      ..drawCircle(Offset(x, y), r, Paint()..color = filled ? c : background)
      ..drawCircle(Offset(x, y), r, ring);
    if (interchange) {
      canvas.drawCircle(Offset(x, y), r - 4.5, ring..strokeWidth = 2);
    }
  }

  void _segment(Canvas canvas, Offset a, Offset b, Color color, bool dashed) {
    final p = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    if (!dashed) {
      canvas.drawLine(a, b, p);
      return;
    }
    const dash = 5.0;
    for (var y = a.dy; y < b.dy; y += dash * 2) {
      canvas.drawLine(
        Offset(a.dx, y),
        Offset(a.dx, (y + dash).clamp(a.dy, b.dy)),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(LineDiagramPainter old) =>
      old.above != above ||
      old.below != below ||
      old.node != node ||
      old.filled != filled ||
      old.interchange != interchange ||
      old.background != background;
}
