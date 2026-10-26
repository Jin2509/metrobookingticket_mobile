import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/parking_control/presentation/widgets/lot_status_card.dart';
import 'package:metro_mobile/features/staff/parking_control/presentation/widgets/parked_vehicle_list.dart';
import 'package:metro_mobile/features/staff/parking_control/presentation/widgets/parking_check_card.dart';
import 'package:metro_mobile/features/staff/shift/presentation/widgets/shift_header.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// S20. Gửi xe tại bãi phụ trách (UC10-03).
class ParkingControlScreen extends StatelessWidget {
  const ParkingControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(MetroSpacing.md),
          children: [
            const ShiftHeader(showLot: true),
            MetroSpacing.gapMd,
            const LotStatusCard(),
            MetroSpacing.gapMd,
            MetroButton(
              label: context.l10n.scanParkingQr,
              icon: LucideIcons.scanLine,
              size: MetroButtonSize.lg,
              expand: true,
              onPressed: () => context.push(Routes.sParkingScan),
            ),
            MetroSpacing.gapMd,
            const ParkingCheckCard(),
            MetroSpacing.gapMd,
            const ParkedVehicleList(),
          ],
        ),
      ),
    );
  }
}
