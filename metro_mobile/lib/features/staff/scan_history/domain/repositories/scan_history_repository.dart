import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';

abstract interface class ScanHistoryRepository {
  /// Lượt quét hôm nay của nhân viên, mới nhất trước.
  Future<List<ScanLogEntry>> getToday();
}
