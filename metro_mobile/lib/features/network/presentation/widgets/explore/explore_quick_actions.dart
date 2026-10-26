import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Ba lối tắt: Bản đồ (P23), Tra lộ trình (P25), Ga gần bạn (P24).
class ExploreQuickActions extends StatelessWidget {
  const ExploreQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final actions = [
      (LucideIcons.map, l.map, Routes.map()),
      (LucideIcons.route, l.routeLookup, Routes.routeSearch()),
      (LucideIcons.locateFixed, l.nearbyStations, Routes.map(nearby: true)),
    ];
    return Row(
      children: [
        for (final (icon, label, path) in actions) ...[
          Expanded(
            child: MetroCard(
              onTap: () => context.push(path),
              padding: const EdgeInsets.symmetric(vertical: MetroSpacing.md),
              child: Column(
                children: [
                  Icon(icon, color: context.colors.primary),
                  MetroSpacing.gapXs,
                  Text(label, style: context.text.labelMedium),
                ],
              ),
            ),
          ),
          if (path != actions.last.$3) MetroSpacing.gapSm,
        ],
      ],
    );
  }
}
