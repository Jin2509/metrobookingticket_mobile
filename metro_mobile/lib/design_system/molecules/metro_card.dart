import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/colors.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Thẻ nổi trên nền bằng bóng mềm (nền tối dùng màu bề mặt), không viền.
/// Có `onTap` thì có hiệu ứng chạm.
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
    final flat = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: MetroRadius.brXl,
        boxShadow: flat || color != null ? null : MetroColors.cardShadow,
      ),
      child: Material(
        color: color ?? m.card,
        borderRadius: MetroRadius.brXl,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
