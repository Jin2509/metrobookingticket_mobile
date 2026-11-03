import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/presentation/controllers/parking_form_controller.dart';
import 'package:metro_mobile/features/parking/presentation/mappers/parking_labels.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/vehicle_chips.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Bước 3: tóm tắt để kiểm tra lần cuối, nói rõ điều gì xảy ra sau khi trả tiền.
class ParkingStepConfirm extends ConsumerWidget {
  const ParkingStepConfirm({required this.lot, super.key});

  final ParkingLot lot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = ref.watch(parkingFormProvider);
    final request = s.requestFor(lot.id);
    final preview = request == null
        ? null
        : ref.watch(parkingPreviewProvider(request)).value;
    final vehicle = VehicleChips.options
        .where((o) => o.$1 == s.vehicle)
        .firstOrNull
        ?.$2
        .label(l);
    Widget row(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: context.text.bodySmall)),
          MetroSpacing.gapSm,
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.text.labelLarge,
            ),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MetroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              row(l.lot, lot.label),
              row(l.vehicleType, vehicle ?? s.vehicle),
              if (s.plate.isNotEmpty) row(l.plate, s.plate),
              row(l.package, parkingPackageLabel(l, s.package)),
              const Divider(height: MetroSpacing.lg),
              Text(
                preview == null ? l.feeEmpty : l.fee(money(preview.fee)),
                textAlign: TextAlign.end,
                style: context.text.titleLarge,
              ),
            ],
          ),
        ),
        MetroSpacing.gapMd,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.qrCode, size: 20, color: context.colors.primary),
            MetroSpacing.gapSm,
            Expanded(
              child: Text(l.parkingAfterPay, style: context.text.bodyMedium),
            ),
          ],
        ),
      ],
    );
  }
}
