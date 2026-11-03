import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Lối vào chức năng chính thứ hai sau đặt vé tàu.
class ParkingEntryCard extends StatelessWidget {
  const ParkingEntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return MetroCard(
      onTap: () => context.push(Routes.pParkingBook),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.metro.secondary,
              borderRadius: MetroRadius.brLg,
            ),
            child: SizedBox.square(
              dimension: 48,
              child: Icon(
                LucideIcons.circleParking,
                color: context.colors.primary,
              ),
            ),
          ),
          MetroSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.parkingEntryTitle, style: context.text.titleMedium),
              ],
            ),
          ),
          MetroSpacing.gapXs,
          MetroButton(
            label: l.parkingEntryAction,
            size: MetroButtonSize.sm,
            onPressed: () => context.push(Routes.pParkingBook),
          ),
        ],
      ),
    );
  }
}
