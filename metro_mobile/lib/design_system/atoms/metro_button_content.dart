import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/atoms/metro_button_style.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';

/// Icon/vòng tải + nhãn bên trong `MetroButton`.
class MetroButtonContent extends StatelessWidget {
  const MetroButtonContent({
    required this.label,
    required this.icon,
    required this.loading,
    required this.expand,
    required this.size,
    required this.color,
    super.key,
  });

  final String label;
  final IconData? icon;
  final bool loading;
  final bool expand;
  final MetroButtonSize size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final iconSize = size.fontSize + 4;
    return Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox.square(
            dimension: iconSize - 2,
            child: CircularProgressIndicator(strokeWidth: 2, color: color),
          )
        else if (icon != null)
          Icon(icon, size: iconSize, color: color),
        if (loading || icon != null) MetroSpacing.gapXs,
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: MetroTypography.body.copyWith(
              color: color,
              fontSize: size.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
