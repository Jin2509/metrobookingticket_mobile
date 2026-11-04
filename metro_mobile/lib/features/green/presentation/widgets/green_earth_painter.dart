import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_earth_land.dart';

/// Kinh độ để Việt Nam nằm giữa mặt Trái Đất đang nhìn.
const earthFacingVietnam = -105.0;

const _rad = math.pi / 180;
const _hcmcLon = 106.7;
const _hcmcLat = 10.8;

/// Vẽ mặt cầu, lục địa, rừng, vị trí TP.HCM, khói và bóng tối theo `health`.
class EarthPainter extends CustomPainter {
  EarthPainter(this.health, this.rotation) : super(repaint: rotation);

  final double health;
  final Animation<double>? rotation;

  Color _mix(int low, int high) => Color.lerp(Color(low), Color(high), health)!;

  /// Chiếu kinh độ, vĩ độ lên mặt cầu. `null`: điểm ở mặt khuất.
  (Offset, double)? _project(double lon, double lat, double r) {
    final lambda = (lon + (rotation?.value ?? earthFacingVietnam)) * _rad;
    final phi = lat * _rad;
    final depth = math.cos(lambda) * math.cos(phi);
    if (depth < -.25) return null;
    return (
      Offset(r * math.cos(phi) * math.sin(lambda), -r * math.sin(phi)),
      math.max(math.cos(lambda), .2),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.width / 2 * .86;
    final sphere = Rect.fromCircle(center: center, radius: r);
    const light = Alignment(-.35, -.4);

    canvas.drawCircle(
      center,
      size.width / 2,
      Paint()
        ..shader = RadialGradient(
          colors: [
            _mix(0xFF9AA5A8, 0xFF7CF0B5).withValues(alpha: .55),
            _mix(0xFF9AA5A8, 0xFF7CF0B5).withValues(alpha: 0),
          ],
          stops: const [.8, 1],
        ).createShader(Rect.fromCircle(center: center, radius: size.width / 2)),
    );
    canvas
      ..save()
      ..clipPath(Path()..addOval(sphere))
      ..drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(
            center: light,
            colors: [
              _mix(0xFF7E98A8, 0xFF4FC3F7),
              _mix(0xFF2C4A5E, 0xFF0B5FA5),
              _mix(0xFF18303F, 0xFF06305C),
            ],
          ).createShader(sphere),
      )
      ..translate(center.dx, center.dy)
      ..rotate(.3);

    final land = Path();
    final forest = Path();
    final forested = (earthLand.length * health).round();
    for (final (i, (lon, lat, deg)) in earthLand.indexed) {
      final p = _project(lon, lat, r);
      if (p == null) continue;
      final (at, squeeze) = p;
      final h = deg * _rad * r;
      land.addOval(
        Rect.fromCenter(center: at, width: h * 2 * squeeze, height: h * 2),
      );
      if (i * 7 % earthLand.length < forested) {
        forest.addOval(
          Rect.fromCenter(center: at, width: h * squeeze, height: h),
        );
      }
    }
    canvas
      ..drawPath(land, Paint()..color = _mix(0xFFB59B6A, 0xFF34C37A))
      ..drawPath(forest, Paint()..color = _mix(0xFF9A8A5C, 0xFF16824A));

    final home = _project(_hcmcLon, _hcmcLat, r);
    if (home != null) {
      canvas
        ..drawCircle(home.$1, r * .055, Paint()..color = Colors.white)
        ..drawCircle(
          home.$1,
          r * .03,
          Paint()..color = const Color(0xFFFF8A3D),
        );
    }
    canvas.rotate(-.3);

    // Khói mỏng dần khi Trái Đất xanh lên.
    final smog = (.5 - health).clamp(0.0, .5);
    if (smog > 0) {
      final paint = Paint()..color = Colors.white.withValues(alpha: smog * .5);
      for (final (x, y, w) in const [
        (-.4, -.45, 1.0),
        (.3, .1, .8),
        (-.2, .55, .9),
      ]) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(x * r, y * r),
            width: w * r,
            height: r * .2,
          ),
          paint,
        );
      }
    }
    canvas
      ..translate(-center.dx, -center.dy)
      ..drawCircle(
        center,
        r,
        Paint()
          ..shader = const RadialGradient(
            center: light,
            radius: 1.1,
            colors: [Color(0x00000000), Color(0x77000000)],
            stops: [.55, 1],
          ).createShader(sphere),
      )
      ..restore();
  }

  @override
  bool shouldRepaint(EarthPainter old) =>
      old.health != health || old.rotation != rotation;
}
