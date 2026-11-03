import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_camera.dart';

const _white = Color(0xFFFFFFFF);

/// Mặt đất mờ kèm lưới, vẽ đè lên phần ngầm để phần đó trông nằm bên dưới.
void paintGround(Canvas canvas, Size size, Network3dCamera camera) {
  const half = 1.3;
  const cells = 10;
  Offset at(double x, double z) => camera.project(Point3(x, 0, z), size).offset;
  final plate = Path()
    ..addPolygon([
      at(-half, -half),
      at(half, -half),
      at(half, half),
      at(-half, half),
    ], true);
  canvas.drawPath(plate, Paint()..color = const Color(0x2E2F7F8F));
  final grid = Paint()
    ..color = const Color(0x1FBFEAF0)
    ..strokeWidth = 1;
  for (var i = 0; i <= cells; i++) {
    final t = -half + half * 2 * i / cells;
    canvas
      ..drawLine(at(t, -half), at(t, half), grid)
      ..drawLine(at(-half, t), at(half, t), grid);
  }
}

/// Bóng đổ của đường ray trên mặt đất.
void paintTrackShadow(Canvas canvas, Projected a, Projected b, double width) {
  canvas.drawLine(
    a.offset,
    b.offset,
    Paint()
      ..color = const Color(0x4D000000)
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round,
  );
}

/// Đoạn ray dạng ống: quầng màu, thân và vệt sáng dọc giữa.
void paintTube(
  Canvas canvas,
  Offset a,
  Offset b, {
  required Color color,
  required double width,
  required bool dashed,
}) {
  Paint stroke(Color c, double w) => Paint()
    ..color = c
    ..strokeWidth = w
    ..strokeCap = dashed ? StrokeCap.butt : StrokeCap.round;
  if (dashed) {
    const dash = 9.0;
    final length = (b - a).distance;
    for (var d = 0.0; d < length; d += dash * 1.8) {
      final from = Offset.lerp(a, b, d / length)!;
      final to = Offset.lerp(a, b, ((d + dash) / length).clamp(0, 1))!;
      canvas.drawLine(from, to, stroke(color, width * .8));
    }
    return;
  }
  canvas
    ..drawLine(
      a,
      b,
      stroke(color.withValues(alpha: color.a * .25), width * 2.4),
    )
    ..drawLine(a, b, stroke(color, width))
    ..drawLine(
      a,
      b,
      stroke(_white.withValues(alpha: color.a * .4), width * .28),
    );
}

/// Trụ đỡ hoặc giếng ngầm nối ga với mặt đất.
void paintPylon(Canvas canvas, Offset top, Offset foot, double opacity) {
  final paint = Paint()
    ..color = _white.withValues(alpha: .28 * opacity)
    ..strokeWidth = 1.4;
  canvas
    ..drawLine(top, foot, paint)
    ..drawCircle(foot, 2, paint);
}

/// Ga dạng cầu: sáng ở góc trên trái, viền trắng, ga đang chọn có quầng.
void paintStation(
  Canvas canvas,
  Offset center,
  double radius,
  Color color, {
  required bool selected,
  required double opacity,
}) {
  if (selected) {
    canvas.drawCircle(
      center,
      radius * 2.1,
      Paint()..color = _white.withValues(alpha: .22),
    );
  }
  canvas
    ..drawCircle(
      center,
      radius,
      Paint()
        ..shader = ui.Gradient.radial(
          center - Offset(radius * .35, radius * .35),
          radius * 1.5,
          [
            Color.lerp(color, _white, .65)!.withValues(alpha: opacity),
            color.withValues(alpha: opacity),
          ],
        ),
    )
    ..drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = selected ? 2 : 1.2
        ..color = _white.withValues(alpha: .9 * opacity),
    );
}
