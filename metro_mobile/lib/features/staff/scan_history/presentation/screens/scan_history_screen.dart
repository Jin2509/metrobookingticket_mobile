import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';
import 'package:metro_mobile/features/staff/scan_history/presentation/controllers/scan_history_providers.dart';
import 'package:metro_mobile/features/staff/scan_history/presentation/mappers/scan_log_labels.dart';
import 'package:metro_mobile/features/staff/scan_history/presentation/widgets/scan_log_tile.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// S30. Lịch sử quét trong ca. Không hiện tên/SĐT hành khách.
class ScanHistoryScreen extends ConsumerStatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  ConsumerState<ScanHistoryScreen> createState() => _ScanHistoryState();
}

class _ScanHistoryState extends ConsumerState<ScanHistoryScreen> {
  ScanLogFilter _filter = ScanLogFilter.all;

  @override
  Widget build(BuildContext context) {
    final provider = scanHistoryProvider(_filter);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.scanHistoryTitle)),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: MetroSpacing.screenPadding,
            child: Row(
              children: [
                for (final f in ScanLogFilter.values) ...[
                  ChoiceChip(
                    label: Text(scanLogFilterLabel(context.l10n, f)),
                    showCheckmark: false,
                    selected: f == _filter,
                    onSelected: (_) => setState(() => _filter = f),
                  ),
                  MetroSpacing.gapXs,
                ],
              ],
            ),
          ),
          Expanded(
            child: AsyncValueView(
              value: ref.watch(provider),
              onRetry: () => ref.invalidate(provider),
              data: (list) => list.isEmpty
                  ? EmptyState(
                      icon: LucideIcons.history,
                      title: context.l10n.noScans,
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.refresh(provider.future),
                      child: ListView(
                        padding: const EdgeInsets.all(MetroSpacing.md),
                        children: [for (final e in list) ScanLogTile(entry: e)],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
