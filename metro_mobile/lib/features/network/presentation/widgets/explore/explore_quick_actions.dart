import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Hai lối vào: Bản đồ (gồm ga gần bạn và quanh ga) và Tra lộ trình.
class ExploreQuickActions extends StatelessWidget {
  const ExploreQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ActionCard(
              icon: LucideIcons.map,
              title: l.map,
              subtitle: l.exploreMapHint,
              onTap: () => context.push(Routes.map()),
            ),
          ),
          MetroSpacing.gapSm,
          Expanded(
            child: _ActionCard(
              icon: LucideIcons.route,
              title: l.routeShort,
              subtitle: l.exploreRouteHint,
              onTap: () => context.push(Routes.routeSearch()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MetroCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: context.colors.primary),
          MetroSpacing.gapXs,
          Text(title, style: context.text.titleMedium),
          Text(subtitle, style: context.text.bodySmall),
        ],
      ),
    );
  }
}
