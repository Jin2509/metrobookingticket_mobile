import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/presentation/controllers/parking_form_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Ga / bãi  [Suối Tiên – Bãi PK1 ▾]`.
class LotSelector extends ConsumerWidget {
  const LotSelector({required this.lots, required this.selected, super.key});

  final List<ParkingLot> lots;
  final ParkingLot? selected;

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final id = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: MetroSpacing.lg),
        children: [
          for (final l in lots)
            ListTile(
              title: Text(l.label),
              selected: l.id == selected?.id,
              onTap: () => Navigator.pop(ctx, l.id),
            ),
        ],
      ),
    );
    if (id != null) ref.read(parkingFormProvider.notifier).setLot(id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StationField(
      label: context.l10n.lot,
      value: selected?.label,
      dotColor: context.colors.primary,
      onTap: () => _pick(context, ref),
    );
  }
}
