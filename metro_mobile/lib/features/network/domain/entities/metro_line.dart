import 'package:flutter/foundation.dart';

/// `metro_line.status`: `ACTIVE` | `UNDER_CONSTRUCTION` (planned) | `INACTIVE`.
enum LineStatus { active, planned, inactive }

/// Đoạn từ ga liền trước đến ga thứ i (`line_station`). Ga đầu tuyến = 0.
@immutable
class LineSegment {
  const LineSegment({
    required this.distanceKm,
    required this.travelSeconds,
    required this.dwellSeconds,
  });

  final double distanceKm;
  final int travelSeconds;

  /// Thời gian dừng tại ga thứ i.
  final int dwellSeconds;
}

/// Tuyến metro (`metro_line` + `line_station` + `operation_config`).
@immutable
class MetroLine {
  const MetroLine({
    required this.id,
    required this.code,
    required this.name,
    required this.colorHex,
    required this.status,
    required this.stationIds,
    this.segments = const [],
    this.description,
    double? lengthKm,
    this.operatingHours,
    this.headway,
  }) : _lengthKm = lengthKm;

  final String id;

  /// `Tuyến 1` / `BTS-01`.
  final String code;

  /// `Bến Thành – Suối Tiên`.
  final String name;

  /// Đọc từ `metro_line.color_hex`, không hard-code (mục 3.3).
  final String colorHex;
  final LineStatus status;

  /// Thứ tự ga theo `line_station.station_order`.
  final List<String> stationIds;

  /// Song song với [stationIds]; rỗng khi chưa có số liệu đoạn.
  final List<LineSegment> segments;
  final String? description;
  final double? _lengthKm;

  /// `05:00–22:00`.
  final String? operatingHours;

  /// `8–10 phút/chuyến`.
  final String? headway;

  bool get isPlanned => status == LineStatus.planned;

  /// Chỉ tuyến đang khai thác mới dùng để tìm lộ trình / hiện tàu chạy.
  bool get isOperating => status == LineStatus.active;

  bool get hasSegments =>
      segments.isNotEmpty && segments.length == stationIds.length;

  /// Tổng `distanceFromPrevKm`, hoặc số cấu hình sẵn.
  double? get lengthKm {
    if (_lengthKm != null) return _lengthKm;
    if (!hasSegments) return null;
    return segments.fold<double>(0, (s, e) => s + e.distanceKm);
  }

  /// Giây chạy từ ga [a] đến ga [b] (chỉ số trong [stationIds], hai chiều):
  /// Σ thời gian chạy các đoạn + Σ thời gian dừng các ga ở giữa (Flow A.4).
  int? travelSeconds(int a, int b) {
    if (!hasSegments) return null;
    final lo = a < b ? a : b;
    final hi = a < b ? b : a;
    var total = 0;
    for (var k = lo + 1; k <= hi; k++) {
      total += segments[k].travelSeconds;
      if (k < hi) total += segments[k].dwellSeconds;
    }
    return total;
  }
}
