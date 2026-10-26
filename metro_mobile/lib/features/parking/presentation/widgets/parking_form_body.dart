import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/domain/usecases/parking_usecases.dart';
import 'package:metro_mobile/features/parking/presentation/controllers/parking_form_controller.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/active_pass_banner.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/capacity_bar.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/lot_selector.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/package_chips.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/plate_field.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/vehicle_chips.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Các trường của P35: bãi, loại xe, biển số, gói, sức chứa, banner A4.
class ParkingFormBody extends ConsumerWidget {
  const ParkingFormBody({required this.lots, super.key});

  final List<ParkingLot> lots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(parkingFormProvider);
    final ctrl = ref.read(parkingFormProvider.notifier);
    final lot = lots.where((l) => l.id == s.lotId).firstOrNull ?? lots.first;
    final request = s.requestFor(lot.id);
    final active = request == null
        ? null
        : ref.watch(parkingPreviewProvider(request)).value?.activePassId;
    Widget label(String t) => Padding(
      padding: const EdgeInsets.only(bottom: MetroSpacing.xs),
      child: Text(t, style: context.text.labelMedium),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LotSelector(lots: lots, selected: lot),
        MetroSpacing.gapMd,
        label(context.l10n.vehicleType),
        VehicleChips(value: s.vehicle, onChanged: ctrl.setVehicle),
        MetroSpacing.gapMd,
        PlateField(
          enabled: s.vehicle != bicycle,
          error: s.plateError,
          onChanged: ctrl.setPlate,
        ),
        MetroSpacing.gapMd,
        label(context.l10n.package),
        PackageChips(value: s.package, onChanged: ctrl.setPackage),
        MetroSpacing.gapMd,
        CapacityBar(capacity: lot.capacityOf(s.vehicle)),
        if (active != null) ...[
          MetroSpacing.gapMd,
          ActivePassBanner(passId: active),
        ],
      ],
    );
  }
}
