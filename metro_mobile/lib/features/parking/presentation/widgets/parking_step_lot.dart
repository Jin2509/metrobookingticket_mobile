import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/presentation/controllers/parking_form_controller.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/capacity_bar.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/vehicle_chips.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Bước 1: loại xe và bãi gửi, mỗi bãi hiện số chỗ trống theo loại xe đã chọn.
class ParkingStepLot extends ConsumerWidget {
  const ParkingStepLot({required this.lots, required this.lot, super.key});

  final List<ParkingLot> lots;
  final ParkingLot lot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(parkingFormProvider);
    final ctrl = ref.read(parkingFormProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.vehicleType, style: context.text.titleMedium),
        MetroSpacing.gapXs,
        VehicleChips(value: s.vehicle, onChanged: ctrl.setVehicle),
        MetroSpacing.gapLg,
        Text(context.l10n.parkingChooseLot, style: context.text.titleMedium),
        MetroSpacing.gapXs,
        for (final l in lots) ...[
          MetroCard(
            onTap: () => ctrl.setLot(l.id),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      l.id == lot.id
                          ? LucideIcons.circleCheck
                          : LucideIcons.circle,
                      color: l.id == lot.id
                          ? context.colors.primary
                          : context.metro.mutedForeground,
                    ),
                    MetroSpacing.gapSm,
                    Expanded(
                      child: Text(l.label, style: context.text.titleSmall),
                    ),
                  ],
                ),
                MetroSpacing.gapSm,
                CapacityBar(capacity: l.capacityOf(s.vehicle)),
              ],
            ),
          ),
          MetroSpacing.gapSm,
        ],
      ],
    );
  }
}
