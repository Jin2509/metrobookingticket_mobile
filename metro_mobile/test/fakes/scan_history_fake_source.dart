import 'package:metro_mobile/features/staff/scan_history/data/sources/scan_history_sources.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/repositories/scan_history_repository.dart';

import 'demo_ledger.dart';

/// Lịch sử trong ca từ `DemoLedger.scanLog` (ghi bởi soát vé + gửi xe).
class ScanHistoryFakeSource implements ScanHistoryRepository {
  const ScanHistoryFakeSource(this._ledger);
  final DemoLedger _ledger;

  @override
  Future<List<ScanLogEntry>> getToday() async =>
      _ledger.scanLog.map(scanLogEntryFromJson).toList();
}
