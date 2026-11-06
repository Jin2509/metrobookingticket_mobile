import 'package:flutter/foundation.dart';

/// Ca làm + ga/bãi được phân công (`staff_station`, UC2-03, chỉ đọc).
@immutable
class StaffShift {
  const StaffShift({
    required this.stationId,
    required this.stationName,
    required this.shiftLabel,
    required this.lotId,
    required this.lotName,
    this.staffOnDuty,
    this.staffLimit,
  });

  final String stationId;
  final String stationName;

  /// `06:00–14:00`.
  final String shiftLabel;
  final String lotId;
  final String lotName;

  /// Số nhân viên đang được phân công tại ga, `null` nếu chưa có dữ liệu.
  final int? staffOnDuty;

  /// Giới hạn nhân viên mỗi ga. Chưa quyết định nên để trống và không ràng buộc.
  final int? staffLimit;
}

/// `Hôm nay: 412 vào · 389 ra · 7 từ chối`.
@immutable
class ShiftStats {
  const ShiftStats({
    required this.entries,
    required this.exits,
    required this.rejected,
  });

  final int entries;
  final int exits;
  final int rejected;
}
