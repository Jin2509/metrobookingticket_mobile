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
  });

  final String stationId;
  final String stationName;

  /// `06:00–14:00`.
  final String shiftLabel;
  final String lotId;
  final String lotName;
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
