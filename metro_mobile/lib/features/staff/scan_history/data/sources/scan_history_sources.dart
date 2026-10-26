import 'package:dio/dio.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/repositories/scan_history_repository.dart';

ScanLogEntry _entry(Map<String, Object?> j) => ScanLogEntry(
  at: DateTime.parse(j['at']! as String),
  parking: j['parking'] == true,
  entry: j['entry'] == true,
  code: j['code']! as String,
  valid: j['valid'] == true,
  label: j['label'] as String? ?? '',
);

/// Lịch sử trong ca từ `DemoLedger.scanLog` (ghi bởi soát vé + gửi xe).
class ScanHistoryFakeSource implements ScanHistoryRepository {
  const ScanHistoryFakeSource(this._ledger);
  final DemoLedger _ledger;

  @override
  Future<List<ScanLogEntry>> getToday() async =>
      _ledger.scanLog.map(_entry).toList();
}

/// Endpoint lịch sử ca chưa có trong bảng API mục 9, cần thống nhất.
class ScanHistoryRemoteSource implements ScanHistoryRepository {
  const ScanHistoryRemoteSource(this._dio);
  final Dio _dio;

  @override
  Future<List<ScanLogEntry>> getToday() async {
    try {
      final res = await _dio.get<List<dynamic>>(
        '/api/staff/scan-history/today',
      );
      return [
        for (final j in res.data ?? const []) _entry(j as Map<String, Object?>),
      ];
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
