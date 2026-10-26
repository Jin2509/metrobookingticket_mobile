import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';

/// Lỗi nghiệp vụ (hết hạn, sai ga…) trả về dưới dạng `ScanInvalid`,
/// lỗi mạng ném `Failure`.
abstract interface class TicketControlRepository {
  /// [qrTokenOrCode]: token trong QR hoặc mã vé nhập tay (A3).
  Future<ScanResult> checkIn({
    required String qrTokenOrCode,
    required String stationId,
    required String idempotencyKey,
  });

  Future<ScanResult> checkOut({
    required String qrTokenOrCode,
    required String stationId,
    required String idempotencyKey,
  });
}
