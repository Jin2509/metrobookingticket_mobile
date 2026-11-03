import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/domain/usecases/parking_usecases.dart';
import 'package:metro_mobile/features/parking/presentation/controllers/parking_form_controller.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/active_pass_banner.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/package_chips.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/plate_field.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Bước 2: biển số và gói gửi. Biển số đang có lượt hiệu lực thì báo ngay (A4).
class ParkingStepDetails extends ConsumerWidget {
  const ParkingStepDetails({required this.lot, super.key});

  final ParkingLot lot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(parkingFormProvider);
    final ctrl = ref.read(parkingFormProvider.notifier);
    final request = s.requestFor(lot.id);
    final active = request == null
        ? null
        : ref.watch(parkingPreviewProvider(request)).value?.activePassId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MetroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PlateField(
                initial: s.plate,
                enabled: s.vehicle != bicycle,
                error: s.plateError,
                onChanged: ctrl.setPlate,
              ),
              MetroSpacing.gapLg,
              Text(context.l10n.package, style: context.text.labelMedium),
              MetroSpacing.gapXs,
              PackageChips(value: s.package, onChanged: ctrl.setPackage),
            ],
          ),
        ),
        if (active != null) ...[
          MetroSpacing.gapMd,
          ActivePassBanner(passId: active),
        ],
      ],
    );
  }
}
