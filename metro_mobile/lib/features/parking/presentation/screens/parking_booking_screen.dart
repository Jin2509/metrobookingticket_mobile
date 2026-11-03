import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/presentation/controllers/parking_form_controller.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/parking_step_bar.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/parking_step_confirm.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/parking_step_details.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/parking_step_lot.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P35. Đặt chỗ gửi xe theo từng bước (UC10-01), rồi tới màn QR thanh toán.
class ParkingBookingScreen extends ConsumerStatefulWidget {
  const ParkingBookingScreen({super.key});

  @override
  ConsumerState<ParkingBookingScreen> createState() => _State();
}

class _State extends ConsumerState<ParkingBookingScreen> {
  int _step = 0;

  ParkingLot _lot(List<ParkingLot> lots) {
    final id = ref.watch(parkingFormProvider.select((s) => s.lotId));
    return lots.where((l) => l.id == id).firstOrNull ?? lots.first;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lots = ref.watch(parkingLotsProvider);
    final list = lots.value ?? const <ParkingLot>[];
    return Scaffold(
      appBar: AppBar(title: Text(l.parkingBookTitle)),
      bottomNavigationBar: list.isEmpty
          ? null
          : ParkingStepBar(
              step: _step,
              lot: _lot(list),
              onStep: (v) => setState(() => _step = v),
            ),
      body: AsyncValueView(
        value: lots,
        onRetry: () => ref.invalidate(parkingLotsProvider),
        data: (list) => ListView(
          padding: const EdgeInsets.all(MetroSpacing.md),
          children: [
            BookingStepper(
              steps: [l.parkingStepLot, l.parkingStepInfo, l.confirm],
              current: _step,
            ),
            MetroSpacing.gapMd,
            MascotTip(
              text: switch (_step) {
                0 => l.mascotParkingLot,
                1 => l.mascotParkingInfo,
                _ => l.mascotParkingConfirm,
              },
            ),
            MetroSpacing.gapMd,
            switch (_step) {
              0 => ParkingStepLot(lots: list, lot: _lot(list)),
              1 => ParkingStepDetails(lot: _lot(list)),
              _ => ParkingStepConfirm(lot: _lot(list)),
            },
          ],
        ),
      ),
    );
  }
}
