import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/purchase_controller.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Ga đi / ga đến + đổi chiều cho vé lượt (P29).
class PurchaseStations extends ConsumerWidget {
  const PurchaseStations({required this.initial, super.key});

  final BookingRequest initial;

  Future<void> _pick(BuildContext context, WidgetRef ref, bool from) async {
    final catalog = await ref.read(catalogProvider.future);
    if (!context.mounted) return;
    final r = ref.read(purchaseProvider(initial));
    final picked = await StationPickerSheet.show(
      context,
      title: from ? context.l10n.chooseFrom : context.l10n.chooseTo,
      stations: catalog.options,
      disabledId: from ? r.toId : r.fromId,
    );
    if (picked == null) return;
    final ctrl = ref.read(purchaseProvider(initial).notifier);
    from ? ctrl.setFrom(picked.id) : ctrl.setTo(picked.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = ref.watch(purchaseProvider(initial));
    final catalog = ref.watch(catalogProvider).value;
    String? name(String? id) => id == null ? null : catalog?.station(id)?.name;
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              StationField(
                label: context.l10n.fromShort,
                value: name(r.fromId),
                dotColor: context.colors.primary,
                onTap: () => _pick(context, ref, true),
              ),
              MetroSpacing.gapXs,
              StationField(
                label: context.l10n.to,
                value: name(r.toId),
                dotColor: context.metro.accent,
                onTap: () => _pick(context, ref, false),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: context.l10n.swap,
          icon: const Icon(LucideIcons.arrowUpDown),
          onPressed: ref.read(purchaseProvider(initial).notifier).swap,
        ),
      ],
    );
  }
}
