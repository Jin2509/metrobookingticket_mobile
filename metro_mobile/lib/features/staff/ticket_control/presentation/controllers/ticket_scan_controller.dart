import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/qr/camera_scanner.dart';
import 'package:metro_mobile/features/staff/shift/presentation/controllers/shift_providers.dart';
import 'package:metro_mobile/features/staff/staff_providers.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/usecases/check_ticket.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/usecases/process_ticket_scan.dart';

/// Giữ bộ nhớ chống trùng 3s suốt phiên (kể cả khi đổi tab).
final processTicketScanProvider = Provider((ref) {
  final repo = ref.watch(ticketControlRepositoryProvider);
  return ProcessTicketScan(
    checkIn: CheckInTicket(repo),
    checkOut: CheckOutTicket(repo),
  );
});

@immutable
class TicketScanState {
  const TicketScanState({
    required this.mode,
    this.busy = false,
    this.result,
    this.toast,
    this.seq = 0,
  });

  final ScanMode mode;

  /// Đang gửi: khóa xử lý mã tiếp theo.
  final bool busy;
  final ScanResult? result;

  /// Thông báo nhanh (không đọc được QR, lỗi mạng).
  final String? toast;

  /// Tăng mỗi lần có kết quả/thông báo mới để UI phản ứng.
  final int seq;
}

final ticketScanProvider = NotifierProvider.autoDispose
    .family<TicketScanController, TicketScanState, ScanMode>(
      TicketScanController.new,
    );

/// S10: đổi chế độ, nhận mã từ camera hoặc nhập tay.
class TicketScanController extends Notifier<TicketScanState> {
  TicketScanController(this.initialMode);
  final ScanMode initialMode;

  @override
  TicketScanState build() => TicketScanState(mode: initialMode);

  void setMode(ScanMode m) => state = TicketScanState(mode: m, seq: state.seq);

  Future<void> onRead(ScanRead read) async {
    switch (read) {
      case ScanDecoded(:final payload):
        await _handle((p, station) => p.payload(payload, state.mode, station));
      case ScanUnreadable():
        _emit(toast: 'Không đọc được mã QR. Quét lại');
    }
  }

  /// A3: QR hỏng → nhập mã vé thủ công.
  Future<void> submitCode(String code) =>
      _handle((p, station) => p.code(code, state.mode, station));

  Future<void> _handle(
    Future<ScanResult?> Function(ProcessTicketScan, String) run,
  ) async {
    if (state.busy) return;
    state = TicketScanState(mode: state.mode, busy: true, seq: state.seq);
    try {
      final shift = await ref.read(shiftProvider.future);
      final result = await run(
        ref.read(processTicketScanProvider),
        shift.stationId,
      );
      if (!ref.mounted) return;
      if (result == null) {
        state = TicketScanState(mode: state.mode, seq: state.seq);
        return;
      }
      ref.invalidate(shiftStatsProvider);
      _emit(result: result);
    } on Failure catch (f) {
      if (ref.mounted) _emit(toast: f.message);
    }
  }

  void _emit({ScanResult? result, String? toast}) => state = TicketScanState(
    mode: state.mode,
    result: result,
    toast: toast,
    seq: state.seq + 1,
  );
}
