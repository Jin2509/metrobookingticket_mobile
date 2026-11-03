import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thẻ xem trước sơ đồ 3D ở tab Khám phá, chạm để mở toàn màn hình.
class Network3dPreviewCard extends ConsumerWidget {
  const Network3dPreviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = context.metro;
    return AsyncValueView(
      value: ref.watch(catalogProvider),
      onRetry: () => ref.invalidate(catalogProvider),
      loading: const MetroSkeleton(height: 300, radius: MetroRadius.xl),
      data: (catalog) => Semantics(
        button: true,
        label: l.network3dTitle,
        excludeSemantics: true,
        child: MetroCard(
          color: m.sidebar,
          padding: EdgeInsets.zero,
          onTap: () => context.push(Routes.pExploreNetwork),
          child: SizedBox(
            height: 300,
            child: Stack(
              children: [
                Positioned.fill(
                  top: 64,
                  child: Network3dView(
                    lines: catalog.diagramLines,
                    interactive: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(MetroSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.network3dTitle,
                        style: MetroTypography.title.copyWith(
                          color: MetroColors.primaryForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: MetroSpacing.md,
                  bottom: MetroSpacing.md,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: m.sidebarPrimary,
                      borderRadius: MetroRadius.brPill,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: MetroSpacing.sm,
                        vertical: MetroSpacing.xs,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l.network3dOpen,
                            style: MetroTypography.label.copyWith(
                              color: m.sidebar,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          MetroSpacing.gapXxs,
                          Icon(
                            LucideIcons.arrowUpRight,
                            size: 16,
                            color: m.sidebar,
                          ),
                        ],
                      ),
                    ),
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
