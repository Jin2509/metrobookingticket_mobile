import 'package:metro_mobile/features/staff/scan_history/data/sources/staff_scan_log.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/repositories/scan_history_repository.dart';

ScanLogEntry scanLogEntryFromJson(Map<String, Object?> j) => ScanLogEntry(
  at: DateTime.parse(j['at']! as String),
  parking: j['parking'] == true,
  entry: j['entry'] == true,
  code: j['code']! as String,
  valid: j['valid'] == true,
  label: j['label'] as String? ?? '',
);

/// Backend chưa có API lịch sử ca: đọc các lượt quét đã làm trên máy này.
class ScanHistoryLocalSource implements ScanHistoryRepository {
  const ScanHistoryLocalSource(this._log);
  final StaffScanLog _log;

  @override
  Future<List<ScanLogEntry>> getToday() async => _log.today();
}
