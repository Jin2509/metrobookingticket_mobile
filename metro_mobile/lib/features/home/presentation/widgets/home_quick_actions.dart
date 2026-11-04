import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/home/presentation/controllers/quick_book_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Ba việc chính: khối Mua vé cao bên trái, Bản đồ và Sơ đồ tuyến xếp dọc bên
/// phải.
class HomeQuickActions extends ConsumerWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final from = ref.watch(quickBookProvider.select((s) => s.fromId));
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _BuyTile(
              label: l.buyTicket,
              onTap: () => context.push(Routes.buy(from: from)),
            ),
          ),
          MetroSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ActionTile(
                  icon: LucideIcons.map,
                  label: l.map,
                  onTap: () => context.push(Routes.places(stationId: from)),
                ),
                MetroSpacing.gapSm,
                _ActionTile(
                  icon: LucideIcons.waypoints,
                  label: l.lineDiagram,
                  onTap: () => context.push(Routes.pExploreNetwork),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyTile extends StatelessWidget {
  const _BuyTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: context.colors.primary,
        borderRadius: MetroRadius.brLg,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(MetroSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  LucideIcons.ticketPlus,
                  size: 32,
                  color: MetroColors.primaryForeground,
                ),
                Text(
                  label,
                  style: context.text.titleLarge?.copyWith(
                    color: MetroColors.primaryForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: context.metro.secondary,
        borderRadius: MetroRadius.brLg,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(MetroSpacing.sm),
            child: Row(
              children: [
                Icon(icon, size: 24, color: context.colors.primary),
                MetroSpacing.gapXs,
                Expanded(child: Text(label, style: context.text.titleSmall)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
