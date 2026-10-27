import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Sơ đồ mạng lưới trong tab Khám phá: chú thích tuyến + sơ đồ, chạm
/// ga mở P22.
class NetworkDiagramSection extends ConsumerWidget {
  const NetworkDiagramSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return AsyncValueView(
      value: ref.watch(catalogProvider),
      onRetry: () => ref.invalidate(catalogProvider),
      loading: const MetroSkeleton(height: 480, radius: MetroRadius.lg),
      data: (catalog) => MetroCard(
        padding: const EdgeInsets.symmetric(vertical: MetroSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: MetroSpacing.md),
              child: Wrap(
                spacing: MetroSpacing.sm,
                runSpacing: MetroSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final line in catalog.lines)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LineChip(line: line.badge),
                        MetroSpacing.gapXxs,
                        Text(
                          line.isPlanned ? l.linePlanned : l.inService,
                          style: context.text.labelSmall,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            NetworkDiagram(
              lines: catalog.diagramLines,
              onStationTap: (id) => context.push(Routes.stationDetail(id)),
            ),
            Text(
              l.diagramHint,
              textAlign: TextAlign.center,
              style: context.text.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
