import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/line_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Danh sách tuyến (UC4-02) với skeleton / lỗi / rỗng.
class LinesSection extends ConsumerWidget {
  const LinesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueView(
      value: ref.watch(catalogProvider),
      onRetry: () => ref.invalidate(catalogProvider),
      loading: const Column(
        children: [
          MetroSkeleton(height: 96, radius: MetroRadius.lg),
          MetroSpacing.gapSm,
          MetroSkeleton(height: 96, radius: MetroRadius.lg),
        ],
      ),
      data: (catalog) => catalog.lines.isEmpty
          ? EmptyState(icon: LucideIcons.map, title: context.l10n.noLines)
          : Column(
              children: [
                for (final line in catalog.lines) ...[
                  LineCard(
                    line: line,
                    onTap: () => context.push(Routes.lineDetail(line.id)),
                  ),
                  MetroSpacing.gapSm,
                ],
              ],
            ),
    );
  }
}
