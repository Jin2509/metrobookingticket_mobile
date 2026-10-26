import 'package:flutter/rendering.dart';

/// Làm tối vùng ngoài khung quét và vẽ 4 góc khung.
class ScanFrameOverlay extends CustomPainter {
  const ScanFrameOverlay({required this.color, this.frameRatio = .68});

  final Color color;

  /// Cạnh khung so với cạnh ngắn của khu vực quét.
  final double frameRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide * frameRatio;
    final frame = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: side,
      height: side,
    );
    final rframe = RRect.fromRectAndRadius(frame, const Radius.circular(16));
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Offset.zero & size),
        Path()..addRRect(rframe),
      ),
      Paint()..color = const Color(0x8C000000),
    );
    final pen = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const len = 28.0;
    for (final (corner, dx, dy) in [
      (frame.topLeft, 1.0, 1.0),
      (frame.topRight, -1.0, 1.0),
      (frame.bottomLeft, 1.0, -1.0),
      (frame.bottomRight, -1.0, -1.0),
    ]) {
      canvas
        ..drawLine(corner, corner + Offset(len * dx, 0), pen)
        ..drawLine(corner, corner + Offset(0, len * dy), pen);
    }
  }

  @override
  bool shouldRepaint(ScanFrameOverlay old) =>
      old.color != color || old.frameRatio != frameRatio;
}
