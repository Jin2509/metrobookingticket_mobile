import 'dart:math';

import 'package:clock/clock.dart' as clk;

import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/qr/qr_payload.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/usecases/check_ticket.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/usecases/dedupe_scan.dart';

/// Ghép luồng soát vé (mục 7.4): sai loại QR → từ chối ngay; trùng mã
/// trong 3s → bỏ qua (`null`); còn lại gọi check-in/out kèm
/// `Idempotency-Key`. 403 (sai ga phân công) → `ScanInvalid(forbidden)`.
class ProcessTicketScan {
  ProcessTicketScan({
    required CheckInTicket checkIn,
    required CheckOutTicket checkOut,
    DedupeScan? dedupe,
    DateTime Function()? clock,
  }) : _checkIn = checkIn,
       _checkOut = checkOut,
       _dedupe = dedupe ?? DedupeScan(clock: clock),
       _clock = clock ?? (() => clk.clock.now());

  final CheckInTicket _checkIn;
  final CheckOutTicket _checkOut;
  final DedupeScan _dedupe;
  final DateTime Function() _clock;
  final _random = Random();

  Future<ScanResult?> payload(
    QrPayload p,
    ScanMode mode,
    String stationId,
  ) async {
    if (p.kind != QrKind.ticket) {
      return ScanInvalid(
        mode: mode,
        at: _clock(),
        reason: RejectReason.wrongKind,
      );
    }
    return await code(p.token, mode, stationId);
  }

  /// Token QR hoặc mã vé nhập tay.
  Future<ScanResult?> code(
    String tokenOrCode,
    ScanMode mode,
    String stationId,
  ) async {
    final value = tokenOrCode.trim();
    if (value.isEmpty || !_dedupe.accept('${mode.code}:$value')) return null;
    final key = '${mode.code}-$value-${_random.nextInt(1 << 32)}';
    try {
      return mode == ScanMode.entry
          ? await _checkIn(value, stationId, key)
          : await _checkOut(value, stationId, key);
    } on ForbiddenFailure {
      return ScanInvalid(
        mode: mode,
        at: _clock(),
        reason: RejectReason.forbidden,
        code: value,
      );
    }
  }
}
