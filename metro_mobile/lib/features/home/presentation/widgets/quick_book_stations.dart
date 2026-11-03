import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/home/presentation/controllers/quick_book_controller.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Ga đi và ga đến trong một khối, nút đổi chiều nằm trên đường chia giữa.
class QuickBookStations extends ConsumerWidget {
  const QuickBookStations({super.key});

  Future<void> _pick(BuildContext context, WidgetRef ref, bool from) async {
    final catalog = await ref.read(catalogProvider.future);
    if (!context.mounted) return;
    final s = ref.read(quickBookProvider);
    final picked = await StationPickerSheet.show(
      context,
      title: from ? context.l10n.chooseFrom : context.l10n.chooseTo,
      stations: catalog.options,
      disabledId: from ? s.toId : s.fromId,
    );
    if (picked == null) return;
    final ctrl = ref.read(quickBookProvider.notifier);
    from ? ctrl.setFrom(picked.id) : ctrl.setTo(picked.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(quickBookProvider);
    final catalog = ref.watch(catalogProvider).value;
    final m = context.metro;
    String? name(String? id) => id == null ? null : catalog?.station(id)?.name;
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: m.muted,
            borderRadius: MetroRadius.brLg,
          ),
          child: Column(
            children: [
              StationField(
                label: context.l10n.fromShort,
                value: name(s.fromId),
                dotColor: context.colors.primary,
                onTap: () => _pick(context, ref, true),
              ),
              Divider(height: 1, color: m.border, indent: MetroSpacing.xl),
              StationField(
                label: context.l10n.to,
                value: name(s.toId),
                dotColor: m.accent,
                onTap: () => _pick(context, ref, false),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: MetroSpacing.xs),
          child: IconButton.filledTonal(
            tooltip: context.l10n.swap,
            icon: const Icon(LucideIcons.arrowUpDown, size: 18),
            onPressed: ref.read(quickBookProvider.notifier).swap,
          ),
        ),
      ],
    );
  }
}
