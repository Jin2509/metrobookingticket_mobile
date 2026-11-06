import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/shift/presentation/widgets/shift_header.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/controllers/ticket_scan_controller.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/widgets/manual_code_button.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/widgets/scan_mode_switch.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/widgets/scan_result_presenter.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/widgets/staff_scan_area.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/widgets/today_stats_strip.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// S00 + S10. Soát vé bằng camera sau: gọn trong một màn để không phải cuộn khi
/// đang quét, chế độ Vào ga / Ra ga nằm gần ngón cái.
class TicketScanScreen extends ConsumerWidget {
  const TicketScanScreen({required this.initialMode, super.key});

  final ScanMode initialMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(ticketScanProvider(initialMode));
    final ctrl = ref.read(ticketScanProvider(initialMode).notifier);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MetroSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ShiftHeader(),
              MetroSpacing.gapSm,
              const TodayStatsStrip(),
              MetroSpacing.gapSm,
              Expanded(
                child: Center(
                  child: StaffScanArea(
                    onRead: ctrl.onRead,
                    busy: s.busy,
                    hint: s.mode == ScanMode.entry
                        ? context.l10n.scanHintEntry
                        : context.l10n.scanHintExit,
                  ),
                ),
              ),
              MetroSpacing.gapSm,
              ScanModeSwitch(value: s.mode, onChanged: ctrl.setMode),
              MetroSpacing.gapXs,
              ManualCodeButton(onSubmit: ctrl.submitCode),
              ScanResultPresenter(mode: initialMode),
            ],
          ),
        ),
      ),
    );
  }
}
