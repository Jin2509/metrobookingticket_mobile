import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/mascot/metro_mascot.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/colors.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Đường ray ngang màn hình, Futu vừa chạy vừa nảy theo [progress] từ 0 tới 1.
class MascotRunTrack extends StatelessWidget {
  const MascotRunTrack({required this.progress, super.key});

  final Animation<double> progress;

  static const _size = 120.0;
  static const _track = 6.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final trail = context.metro.sidebarPrimary;
    return SizedBox(
      height: _size + _track + MetroSpacing.sm,
      child: AnimatedBuilder(
        animation: progress,
        builder: (_, _) {
          final t = progress.value;
          final x = -_size + (width + _size) * t;
          final bob = math.sin(t * math.pi * 10).abs();
          return Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _track,
                child: ColoredBox(
                  color: MetroColors.primaryForeground.withValues(alpha: .16),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                width: (x + _size / 2).clamp(0, width),
                height: _track,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: trail,
                    borderRadius: MetroRadius.brPill,
                  ),
                ),
              ),
              Positioned(
                left: x,
                bottom: _track + bob * MetroSpacing.sm,
                child: Transform.rotate(
                  angle: .05 + bob * .05,
                  child: const MetroMascot(size: _size, mood: MascotMood.happy),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
