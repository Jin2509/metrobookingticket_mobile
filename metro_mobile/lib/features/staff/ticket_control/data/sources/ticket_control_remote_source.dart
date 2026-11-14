import 'package:dio/dio.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/staff/scan_history/data/sources/staff_scan_log.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/repositories/ticket_control_repository.dart';

typedef _Json = Map<String, Object?>;

/// `POST /api/v1/gates/check-in|check-out {qrToken, stationId}`. Từ chối
/// vẫn trả 200 với `result = REJECTED` và `reason` tiếng Việt. Mỗi lượt quét
/// được ghi vào [StaffScanLog] cho lịch sử ca.
class TicketControlRemoteSource implements TicketControlRepository {
  TicketControlRemoteSource(this._dio, this._log);
  final Dio _dio;
  final StaffScanLog _log;

  /// Mã loại vé → tên, tải một lần từ `/public/ticket-products`.
  Map<String, String>? _names;

  Future<Map<String, String>> _productNames() async {
    if (_names case final n?) return n;
    try {
      final res = await _dio.get<List<dynamic>>(
        '/api/v1/public/ticket-products',
      );
      return _names = {
        for (final p in (res.data ?? const []).cast<_Json>())
          '${p['code']}': '${p['name']}',
      };
    } on DioException {
      return const {};
    }
  }

  /// Đoán loại lỗi từ câu chữ backend để chọn icon/nhãn; nội dung hiển thị
  /// vẫn là [ScanInvalid.detail].
  static RejectReason _reason(String? text) {
    final t = (text ?? '').toLowerCase();
    if (t.contains('hết hạn') || t.contains('quá hạn')) {
      return RejectReason.expired;
    }
    if (t.contains('chưa được quẹt vào')) return RejectReason.notIn;
    if (t.contains('trong hành trình')) return RejectReason.alreadyIn;
    if (t.contains('chỉ được vào tại ga')) return RejectReason.wrongStation;
    if (t.contains('không tìm thấy')) return RejectReason.notFound;
    return RejectReason.used;
  }

  Future<ScanResult> _scan(
    String path,
    String qrToken,
    String stationId,
    ScanMode mode,
  ) async {
    final names = await _productNames();
    ScanResult result;
    try {
      final res = await _dio.post<_Json>(
        path,
        data: {'qrToken': qrToken, 'stationId': int.parse(stationId)},
      );
      final j = res.data ?? const {};
      final code = j['ticketCode'] as String? ?? qrToken;
      final product = '${j['productCode'] ?? ''}';
      if (j['result'] == 'ACCEPTED') {
        result = ScanValid(
          mode: mode,
          at: DateTime.now(),
          code: code,
          typeName: names[product] ?? product,
          validUntil: DateTime.parse(
            (j['validUntil'] ?? j['validatedAt'])! as String,
          ),
        );
      } else {
        final reason = j['reason'] as String?;
        final fare = (j['fareDifferenceVnd'] as num?)?.toInt();
        result = ScanInvalid(
          mode: mode,
          at: DateTime.now(),
          reason: _reason(reason),
          code: code,
          detail: fare != null && fare > 0
              ? '${reason ?? 'Vé lượt ra quá ga đã mua'} '
                    '(cần thu thêm $fare đ)'
              : reason,
        );
      }
    } on DioException catch (e) {
      final failure = mapDioError(e);
      if (failure is! NotFoundFailure) throw failure;
      result = ScanInvalid(
        mode: mode,
        at: DateTime.now(),
        reason: RejectReason.notFound,
        detail: failure.message,
      );
    }
    _log.add(
      ScanLogEntry(
        at: result.at,
        parking: false,
        entry: mode == ScanMode.entry,
        code: result.code ?? qrToken,
        valid: result is ScanValid,
        label: switch (result) {
          ScanValid(:final typeName) => typeName,
          ScanInvalid(:final detail, :final reason) => detail ?? reason.message,
        },
      ),
    );
    return result;
  }

  @override
  Future<ScanResult> checkIn({
    required String qrTokenOrCode,
    required String stationId,
    required String idempotencyKey,
  }) =>
      _scan('/api/v1/gates/check-in', qrTokenOrCode, stationId, ScanMode.entry);

  @override
  Future<ScanResult> checkOut({
    required String qrTokenOrCode,
    required String stationId,
    required String idempotencyKey,
  }) =>
      _scan('/api/v1/gates/check-out', qrTokenOrCode, stationId, ScanMode.exit);
}
