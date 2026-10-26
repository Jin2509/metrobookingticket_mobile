import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/staff/staff_demo.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/repositories/ticket_control_repository.dart';

/// Soát vé demo: kiểm tra token sinh từ app Passenger (cùng `DemoLedger`)
/// và bộ QR mẫu. Cùng `Idempotency-Key` → trả lại kết quả cũ.
class TicketControlFakeSource implements TicketControlRepository {
  TicketControlFakeSource(
    this._ledger, {
    this.latency = const Duration(milliseconds: 250),
  });

  final DemoLedger _ledger;
  final Duration latency;
  final _done = <String, ScanResult>{};

  @override
  Future<ScanResult> checkIn({
    required String qrTokenOrCode,
    required String stationId,
    required String idempotencyKey,
  }) => _run(qrTokenOrCode, stationId, idempotencyKey, ScanMode.entry);

  @override
  Future<ScanResult> checkOut({
    required String qrTokenOrCode,
    required String stationId,
    required String idempotencyKey,
  }) => _run(qrTokenOrCode, stationId, idempotencyKey, ScanMode.exit);

  Future<ScanResult> _run(
    String token,
    String station,
    String key,
    ScanMode mode,
  ) async {
    await Future<void>.delayed(latency);
    if (station != StaffDemo.stationId) throw const ForbiddenFailure();
    final cached = _done[key];
    if (cached != null) return cached;
    final t = _ledger.findTicket(token);
    final now = _ledger.clock();
    final result = t == null
        ? ScanInvalid(mode: mode, at: now, reason: RejectReason.notFound)
        : _apply(t, mode, now);
    _done[key] = result;
    _log(result, t);
    return result;
  }

  ScanResult _apply(Record t, ScanMode mode, DateTime now) {
    final code = t['code']! as String;
    final route = t['fromName'] == null
        ? null
        : '${t['fromName']} – ${t['toName']}';
    ScanInvalid reject(RejectReason r) => ScanInvalid(
      mode: mode,
      at: now,
      reason: r,
      code: code,
      route: route,
      currentStation: r == RejectReason.wrongStation
          ? StaffDemo.stationName
          : null,
    );
    final status = t['status']! as String;
    final expired = DateTime.parse(t['validUntil']! as String).isBefore(now);
    if (status == 'USED') return reject(RejectReason.used);
    if (status == 'EXPIRED' || status == 'CANCELLED' || expired) {
      return reject(RejectReason.expired);
    }
    final single = t['typeCode'] == 'SINGLE';
    if (mode == ScanMode.entry) {
      if (status == 'IN_USE') return reject(RejectReason.alreadyIn);
      t['status'] = 'IN_USE';
    } else {
      if (status != 'IN_USE') return reject(RejectReason.notIn);
      if (single && t['toId'] != StaffDemo.stationId) {
        return reject(RejectReason.wrongStation);
      }
      // Vé lượt dùng xong; vé ngày/tháng quay về "Chưa sử dụng".
      t['status'] = single ? 'USED' : 'PAID';
    }
    return ScanValid(
      mode: mode,
      at: now,
      code: code,
      typeName: t['typeName']! as String,
      validUntil: DateTime.parse(t['validUntil']! as String),
      route: route,
    );
  }

  void _log(ScanResult r, Record? t) => _ledger.scanLog.insert(0, {
    'at': r.at.toUtc().toIso8601String(),
    'parking': false,
    'entry': r.mode == ScanMode.entry,
    'code': r.code ?? '—',
    'valid': r is ScanValid,
    'label': switch (r) {
      ScanValid(:final typeName) => typeName,
      ScanInvalid(:final reason) => reason.message,
    },
  });
}
