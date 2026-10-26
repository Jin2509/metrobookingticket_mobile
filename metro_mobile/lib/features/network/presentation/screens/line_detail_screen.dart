import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/line_detail/line_header.dart';
import 'package:metro_mobile/features/network/presentation/widgets/line_detail/line_live_chip.dart';
import 'package:metro_mobile/features/network/presentation/widgets/line_detail/line_stations_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P21. Chi tiết tuyến.
class LineDetailScreen extends ConsumerWidget {
  const LineDetailScreen({required this.lineId, super.key});

  final String lineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider);
    final line = catalog.value?.line(lineId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          line == null ? context.l10n.line : '${line.code} · ${line.name}',
        ),
      ),
      body: AsyncValueView(
        value: catalog,
        onRetry: () => ref.invalidate(catalogProvider),
        data: (c) => line == null
            ? EmptyState(
                icon: LucideIcons.mapPinOff,
                title: context.l10n.lineNotFound,
              )
            : ListView(
                padding: const EdgeInsets.all(MetroSpacing.md),
                children: [
                  LineHeader(
                    line: line,
                    live: line.isPlanned ? null : const LineLiveChip(),
                  ),
                  MetroSpacing.gapMd,
                  LineStationsCard(catalog: c, line: line),
                ],
              ),
      ),
    );
  }
}
