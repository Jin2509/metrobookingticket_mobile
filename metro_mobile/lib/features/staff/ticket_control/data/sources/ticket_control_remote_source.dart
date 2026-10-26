import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/repositories/ticket_control_repository.dart';

typedef _Json = Map<String, Object?>;

/// `POST /api/staff/tickets/check-in|check-out` (mục 9) kèm
/// `Idempotency-Key`. 400/404 có `code` → `ScanInvalid`.
class TicketControlRemoteSource implements TicketControlRepository {
  const TicketControlRemoteSource(this._dio);
  final Dio _dio;

  static const _reasons = {
    'EXPIRED': RejectReason.expired,
    'USED': RejectReason.used,
    'ALREADY_CHECKED_IN': RejectReason.alreadyIn,
    'NOT_CHECKED_IN': RejectReason.notIn,
    'WRONG_STATION': RejectReason.wrongStation,
    'NOT_FOUND': RejectReason.notFound,
  };

  Future<ScanResult> _post(
    String path,
    _Json body,
    String key,
    ScanMode mode,
  ) async {
    try {
      final res = await _dio.post<_Json>(
        path,
        data: body,
        options: Options(headers: {'Idempotency-Key': key}),
      );
      final j = res.data ?? const {};
      return ScanValid(
        mode: mode,
        at: DateTime.now(),
        code: '${j['ticketCode']}',
        typeName: j['ticketType'] as String? ?? 'Vé',
        validUntil: DateTime.parse(j['validUntil']! as String),
        route: j['route'] as String?,
      );
    } on DioException catch (e) {
      final raw = e.response?.data;
      final data = raw is Map<String, Object?>
          ? raw
          : const <String, Object?>{};
      final reason = _reasons[data['code']];
      if (reason == null) throw mapDioError(e);
      return ScanInvalid(
        mode: mode,
        at: DateTime.now(),
        reason: reason,
        code: data['ticketCode'] as String?,
        route: data['route'] as String?,
        currentStation: data['currentStation'] as String?,
      );
    }
  }

  @override
  Future<ScanResult> checkIn({
    required String qrTokenOrCode,
    required String stationId,
    required String idempotencyKey,
  }) => _post(
    '/api/staff/tickets/check-in',
    {'qrToken': qrTokenOrCode},
    idempotencyKey,
    ScanMode.entry,
  );

  @override
  Future<ScanResult> checkOut({
    required String qrTokenOrCode,
    required String stationId,
    required String idempotencyKey,
  }) => _post(
    '/api/staff/tickets/check-out',
    {'qrToken': qrTokenOrCode, 'stationId': stationId},
    idempotencyKey,
    ScanMode.exit,
  );
}
