import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Khối giữ chỗ khi đang tải (mục 10.1), nhấp nháy nhẹ thay spinner.
class MetroSkeleton extends StatefulWidget {
  const MetroSkeleton({
    this.width,
    this.height = 16,
    this.radius = MetroRadius.sm,
    super.key,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<MetroSkeleton> createState() => _MetroSkeletonState();
}

class _MetroSkeletonState extends State<MetroSkeleton>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: .45,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.loading,
      child: FadeTransition(
        opacity: _pulse,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: context.metro.muted,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        ),
      ),
    );
  }
}
