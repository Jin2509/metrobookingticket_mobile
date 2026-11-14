import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';

/// Các lượt quét nhân viên đã làm trên máy này trong phiên. Backend chưa có
/// API lịch sử ca và thống kê, nên lịch sử + số liệu hôm nay lấy từ đây.
class StaffScanLog {
  StaffScanLog({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;
  final DateTime Function() _clock;

  final _entries = <ScanLogEntry>[];

  void add(ScanLogEntry e) => _entries.insert(0, e);

  /// Lượt quét trong ngày hiện tại (giờ máy), mới nhất trước.
  List<ScanLogEntry> today() {
    final now = _clock();
    return [
      for (final e in _entries)
        if (e.at.year == now.year &&
            e.at.month == now.month &&
            e.at.day == now.day)
          e,
    ];
  }
}
