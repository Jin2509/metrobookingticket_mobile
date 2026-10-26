import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/parking/presentation/controllers/parking_form_controller.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/parking_form_body.dart';
import 'package:metro_mobile/features/parking/presentation/widgets/parking_pay_bar.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P35. Đăng ký gửi xe (UC10-01).
class ParkingBookingScreen extends ConsumerWidget {
  const ParkingBookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lots = ref.watch(parkingLotsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navParking)),
      bottomNavigationBar: lots.hasValue && lots.requireValue.isNotEmpty
          ? ParkingPayBar(lots: lots.requireValue)
          : null,
      body: AsyncValueView(
        value: lots,
        onRetry: () => ref.invalidate(parkingLotsProvider),
        data: (list) => ListView(
          padding: const EdgeInsets.all(MetroSpacing.md),
          children: [MetroCard(child: ParkingFormBody(lots: list))],
        ),
      ),
    );
  }
}
