import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `● Từ  [Tao Đàn          ▾]` – chạm để mở StationPickerSheet.
class StationField extends StatelessWidget {
  const StationField({
    required this.label,
    required this.value,
    required this.onTap,
    this.dotColor,
    super.key,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Semantics(
      button: true,
      label: '$label: ${value ?? context.l10n.notSelected}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: MetroRadius.brLg,
        child: Container(
          height: MetroSpacing.minTouch,
          padding: const EdgeInsets.symmetric(horizontal: MetroSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: MetroRadius.brLg,
            border: Border.all(color: m.border),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.circleDot,
                size: 16,
                color: dotColor ?? m.mutedForeground,
              ),
              MetroSpacing.gapXs,
              SizedBox(
                width: 36,
                child: Text(label, style: context.text.labelSmall),
              ),
              Expanded(
                child: Text(
                  value ?? context.l10n.chooseStation,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodyLarge?.copyWith(
                    color: value == null ? m.mutedForeground : null,
                  ),
                ),
              ),
              Icon(LucideIcons.chevronDown, size: 18, color: m.mutedForeground),
            ],
          ),
        ),
      ),
    );
  }
}
