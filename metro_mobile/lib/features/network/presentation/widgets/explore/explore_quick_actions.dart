import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Lối tắt: Bản đồ (P23), Tra lộ trình (P25), Ga gần bạn (P24),
/// Quanh ga (P27).
class ExploreQuickActions extends StatelessWidget {
  const ExploreQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return QuickActionGrid(
      actions: [
        QuickAction(LucideIcons.map, l.map, () => context.push(Routes.map())),
        QuickAction(
          LucideIcons.route,
          l.routeShort,
          () => context.push(Routes.routeSearch()),
        ),
        QuickAction(
          LucideIcons.locateFixed,
          l.nearbyStations,
          () => context.push(Routes.map(nearby: true)),
        ),
        QuickAction(
          LucideIcons.mapPinned,
          l.tabNearby,
          () => context.push(Routes.places()),
        ),
      ],
    );
  }
}
