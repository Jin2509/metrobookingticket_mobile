import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Logo chữ "METRO TP.HCM" kèm biểu tượng tàu.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: m.sidebarPrimary,
            borderRadius: MetroRadius.brLg,
          ),
          child: const Padding(
            padding: EdgeInsets.all(MetroSpacing.xs),
            child: Icon(
              LucideIcons.trainFront,
              color: MetroColors.sidebar,
              size: 28,
            ),
          ),
        ),
        MetroSpacing.gapSm,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'METRO TP.HCM',
              style: context.text.titleLarge?.copyWith(
                color: MetroColors.primaryForeground,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              context.l10n.tagline,
              style: context.text.labelSmall?.copyWith(
                color: m.sidebarForeground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
