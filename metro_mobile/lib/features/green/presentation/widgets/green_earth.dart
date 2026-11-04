import 'package:flutter/material.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_earth_painter.dart';

export 'package:metro_mobile/features/green/presentation/widgets/green_earth_painter.dart'
    show earthFacingVietnam;

/// Mô hình Trái Đất vẽ bằng code. [health] từ 0 tới 1: thấp thì đất khô, có
/// khói; cao thì đất xanh, có rừng. [rotation] là góc xoay theo độ.
class GreenEarth extends StatelessWidget {
  const GreenEarth({
    required this.size,
    required this.health,
    this.rotation,
    super.key,
  });

  final double size;
  final double health;
  final Animation<double>? rotation;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.square(size),
        painter: EarthPainter(health, rotation),
      ),
    );
  }
}
