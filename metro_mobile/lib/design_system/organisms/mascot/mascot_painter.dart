import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

/// Tâm trạng của Luke.
enum MascotMood { normal, happy, worried, sad }

/// Vẽ Luke trên khung 100×100: thân tàu, kính lái làm khuôn mặt, đèn pha.
class MascotPainter extends CustomPainter {
  const MascotPainter({required this.blink, this.mood = MascotMood.normal});

  final bool blink;
  final MascotMood mood;

  static const _body = Color(0xFF00BEC7);
  static const _bodyDark = Color(0xFF00767E);
  static const _visor = Color(0xFF06192C);
  static const _light = Color(0xFFFFD27A);
  static const _white = Color(0xFFFFFFFF);
  static const _cheek = Color(0x66FF8A80);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 100);
    RRect box(double l, double t, double r, double b, double radius) =>
        RRect.fromLTRBR(l, t, r, b, Radius.circular(radius));
    final ink = Paint()..color = _bodyDark;

    // Bánh xe, cần lấy điện, thân
    canvas
      ..drawCircle(const Offset(32, 90), 7, ink)
      ..drawCircle(const Offset(68, 90), 7, ink)
      ..drawLine(
        const Offset(50, 16),
        const Offset(62, 4),
        ink
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round,
      )
      ..drawCircle(const Offset(63, 4), 3.5, Paint()..color = _light)
      ..drawRRect(box(14, 14, 86, 88, 22), Paint()..color = _body)
      ..drawRRect(box(14, 70, 86, 88, 14), Paint()..color = _bodyDark)
      // Kính lái làm khuôn mặt
      ..drawRRect(box(23, 25, 77, 62, 15), Paint()..color = _visor);

    final eye = Paint()..color = _white;
    final line = Paint()
      ..color = _white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    if (mood == MascotMood.worried || mood == MascotMood.sad) {
      // Lông mày nhướn lên giữa trán.
      canvas
        ..drawLine(const Offset(33, 33), const Offset(44, 30), line)
        ..drawLine(const Offset(67, 33), const Offset(56, 30), line);
    }
    for (final x in [39.0, 61.0]) {
      if (mood == MascotMood.happy) {
        // Mắt cười hình vòng cung.
        canvas.drawArc(
          Rect.fromCenter(center: Offset(x, 43), width: 13, height: 12),
          math.pi,
          math.pi,
          false,
          line,
        );
      } else if (blink) {
        canvas.drawRRect(box(x - 6, 40, x + 6, 43, 2), eye);
      } else {
        canvas
          ..drawCircle(Offset(x, 41), 6.5, eye)
          ..drawCircle(Offset(x + 1.2, 42), 3.2, Paint()..color = _visor)
          ..drawCircle(Offset(x + 2.4, 40), 1.1, eye);
      }
    }
    if (mood == MascotMood.sad) {
      // Giọt nước mắt.
      canvas.drawCircle(
        const Offset(33, 52),
        2.6,
        Paint()..color = const Color(0xFF8FD8FF),
      );
    }
    canvas
      ..drawCircle(const Offset(30, 52), 3.6, Paint()..color = _cheek)
      ..drawCircle(const Offset(70, 52), 3.6, Paint()..color = _cheek)
      ..drawArc(
        switch (mood) {
          MascotMood.happy => const Rect.fromLTWH(40, 44, 20, 13),
          MascotMood.worried ||
          MascotMood.sad => const Rect.fromLTWH(44, 50, 12, 8),
          MascotMood.normal => const Rect.fromLTWH(43, 46, 14, 10),
        },
        mood == MascotMood.worried || mood == MascotMood.sad
            ? math.pi + .3
            : .2,
        math.pi - .4,
        false,
        line,
      )
      // Đèn pha
      ..drawCircle(const Offset(29, 79), 4.2, Paint()..color = _light)
      ..drawCircle(const Offset(71, 79), 4.2, Paint()..color = _light);
  }

  @override
  bool shouldRepaint(MascotPainter oldDelegate) =>
      oldDelegate.blink != blink || oldDelegate.mood != mood;
}
