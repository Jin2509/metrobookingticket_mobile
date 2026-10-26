import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Card nền trắng, viền mảnh, bo 12. Có `onTap` thì có hiệu ứng chạm.
class MetroCard extends StatelessWidget {
  const MetroCard({
    required this.child,
    this.padding = const EdgeInsets.all(MetroSpacing.md),
    this.onTap,
    this.color,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Material(
      color: color ?? m.card,
      shape: RoundedRectangleBorder(
        borderRadius: MetroRadius.brLg,
        side: BorderSide(color: m.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
