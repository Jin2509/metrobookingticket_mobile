import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/map_filter_controller.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `(Tất cả)(Tuyến 1)(Tuyến 2)(Buýt)` – lọc lớp bản đồ (UC5-01 A1).
class MapFilterBar extends ConsumerWidget {
  const MapFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(catalogProvider).value?.lines ?? const [];
    final filter = ref.watch(mapFilterProvider);
    final ctrl = ref.read(mapFilterProvider.notifier);
    final m = context.metro;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: MetroSpacing.screenPadding,
      child: Row(
        children: [
          ChoiceChip(
            label: Text(context.l10n.all),
            showCheckmark: false,
            selected: filter.lineId == null,
            onSelected: (_) => ctrl.selectLine(null),
          ),
          for (final l in lines) ...[
            MetroSpacing.gapXs,
            LineChip(
              line: l.badge,
              selected: filter.lineId == l.id,
              onTap: () => ctrl.selectLine(l.id),
            ),
          ],
          MetroSpacing.gapXs,
          FilterChip(
            avatar: Icon(LucideIcons.bus, size: 16, color: m.bus),
            label: Text(context.l10n.bus),
            showCheckmark: false,
            selected: filter.showBus,
            selectedColor: m.bus.withValues(alpha: .18),
            onSelected: (_) => ctrl.toggleBus(),
          ),
        ],
      ),
    );
  }
}
