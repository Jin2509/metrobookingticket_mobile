import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/repositories/scan_history_repository.dart';

/// S30. Lịch sử quét trong ca, lọc theo loại.
class GetScanHistory {
  const GetScanHistory(this._repo);
  final ScanHistoryRepository _repo;

  Future<List<ScanLogEntry>> call(ScanLogFilter filter) async =>
      (await _repo.getToday()).where(filter.matches).toList();
}
