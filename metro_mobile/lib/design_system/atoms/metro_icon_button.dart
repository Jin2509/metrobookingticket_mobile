import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';

/// Nút icon 48×48, có badge số (VD chuông thông báo).
class MetroIconButton extends StatelessWidget {
  const MetroIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.badgeCount = 0,
    this.color,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final int badgeCount;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final badge = badgeCount > 99 ? '99+' : '$badgeCount';
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onPressed,
        radius: MetroSpacing.minTouch / 2,
        child: SizedBox.square(
          dimension: MetroSpacing.minTouch,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 22, color: color ?? context.colors.onSurface),
              if (badgeCount > 0)
                Positioned(
                  top: 6,
                  right: 4,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 18),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: m.destructive,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      badge,
                      textAlign: TextAlign.center,
                      style: MetroTypography.label.copyWith(
                        color: context.colors.onError,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
