import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/route_search_controller.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Chọn ga đi/đến, đổi chiều, tìm. Lỗi A1/A2 hiện ngay dưới form.
class RouteFormCard extends ConsumerWidget {
  const RouteFormCard({required this.query, super.key});

  final RouteQuery query;

  Future<void> _pick(BuildContext context, WidgetRef ref, bool from) async {
    final catalog = await ref.read(catalogProvider.future);
    if (!context.mounted) return;
    final state = ref.read(routeSearchProvider(query));
    final picked = await StationPickerSheet.show(
      context,
      title: from ? context.l10n.chooseFrom : context.l10n.chooseTo,
      stations: catalog.options,
      disabledId: from ? state.toId : state.fromId,
    );
    if (picked == null) return;
    final ctrl = ref.read(routeSearchProvider(query).notifier);
    from ? ctrl.setFrom(picked.id) : ctrl.setTo(picked.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routeSearchProvider(query));
    final ctrl = ref.read(routeSearchProvider(query).notifier);
    final catalog = ref.watch(catalogProvider).value;
    String? name(String? id) => id == null ? null : catalog?.station(id)?.name;
    return MetroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    StationField(
                      label: context.l10n.from,
                      value: name(state.fromId),
                      dotColor: context.colors.primary,
                      onTap: () => _pick(context, ref, true),
                    ),
                    MetroSpacing.gapXs,
                    StationField(
                      label: context.l10n.to,
                      value: name(state.toId),
                      dotColor: context.metro.accent,
                      onTap: () => _pick(context, ref, false),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: context.l10n.swap,
                onPressed: ctrl.swap,
                icon: const Icon(LucideIcons.arrowUpDown),
              ),
            ],
          ),
          if (state.inputError != null) ...[
            MetroSpacing.gapXs,
            Text(
              state.inputError!,
              style: context.text.bodySmall?.copyWith(
                color: context.metro.destructive,
              ),
            ),
          ],
          MetroSpacing.gapSm,
          MetroButton(
            label: context.l10n.findRoute,
            expand: true,
            loading: state.searching,
            onPressed: ctrl.search,
          ),
        ],
      ),
    );
  }
}
