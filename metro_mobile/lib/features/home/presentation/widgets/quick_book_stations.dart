import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/home/presentation/controllers/quick_book_controller.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `● Ga đi  Bến Thành  ⇅` / `● Ga đến  Thủ Đức` (chạm 1).
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
    String? name(String? id) => id == null ? null : catalog?.station(id)?.name;
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              StationField(
                label: context.l10n.fromShort,
                value: name(s.fromId),
                dotColor: context.colors.primary,
                onTap: () => _pick(context, ref, true),
              ),
              MetroSpacing.gapXs,
              StationField(
                label: context.l10n.to,
                value: name(s.toId),
                dotColor: context.metro.accent,
                onTap: () => _pick(context, ref, false),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: context.l10n.swap,
          icon: const Icon(LucideIcons.arrowUpDown),
          onPressed: ref.read(quickBookProvider.notifier).swap,
        ),
      ],
    );
  }
}
