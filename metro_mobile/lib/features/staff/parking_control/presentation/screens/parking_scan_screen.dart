import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/parking_control/presentation/controllers/parking_control_controller.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/widgets/staff_scan_area.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// S21. Quét QR gửi xe; có kết quả thì quay lại S20.
class ParkingScanScreen extends ConsumerWidget {
  const ParkingScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(parkingControlProvider.select((s) => s.busy));
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.scanParkingQr)),
      body: ListView(
        padding: const EdgeInsets.all(MetroSpacing.md),
        children: [
          StaffScanArea(
            busy: busy,
            onRead: (read) async {
              final done = await ref
                  .read(parkingControlProvider.notifier)
                  .onRead(read);
              if (done && context.mounted) context.pop();
            },
          ),
        ],
      ),
    );
  }
}
