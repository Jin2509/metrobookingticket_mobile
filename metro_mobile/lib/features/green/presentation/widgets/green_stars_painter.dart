import 'package:flutter/material.dart';

/// Bầu trời sao cố định phía sau Trái Đất.
class GreenStarsPainter extends CustomPainter {
  static const _stars = [
    (.08, .05),
    (.22, .14),
    (.9, .04),
    (.78, .16),
    (.12, .24),
    (.93, .26),
    (.3, .03),
    (.66, .06),
    (.05, .34),
    (.84, .36),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .6);
    for (final (i, (x, y)) in _stars.indexed) {
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        i.isEven ? 1.2 : .8,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GreenStarsPainter old) => false;
}
