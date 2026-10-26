import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/repositories/ticket_control_repository.dart';

/// UC12-01 Check-in vé tại ga phụ trách.
class CheckInTicket {
  const CheckInTicket(this._repo);
  final TicketControlRepository _repo;

  Future<ScanResult> call(String tokenOrCode, String stationId, String key) =>
      _repo.checkIn(
        qrTokenOrCode: tokenOrCode,
        stationId: stationId,
        idempotencyKey: key,
      );
}

/// UC12-02 Check-out vé (gửi kèm ga hiện tại).
class CheckOutTicket {
  const CheckOutTicket(this._repo);
  final TicketControlRepository _repo;

  Future<ScanResult> call(String tokenOrCode, String stationId, String key) =>
      _repo.checkOut(
        qrTokenOrCode: tokenOrCode,
        stationId: stationId,
        idempotencyKey: key,
      );
}
