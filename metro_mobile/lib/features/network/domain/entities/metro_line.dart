import 'package:flutter/foundation.dart';

enum LineStatus { active, planned }

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
    this.lengthKm,
    this.operatingHours,
    this.headway,
  });

  final String id;

  /// `Tuyến 1`.
  final String code;

  /// `Bến Thành – Suối Tiên`.
  final String name;

  /// Đọc từ `metro_line.color_hex`, không hard-code (mục 3.3).
  final String colorHex;
  final LineStatus status;

  /// Thứ tự ga theo `line_station.station_order`.
  final List<String> stationIds;
  final double? lengthKm;

  /// `05:00–22:00`.
  final String? operatingHours;

  /// `8–10 phút/chuyến`.
  final String? headway;

  bool get isPlanned => status == LineStatus.planned;
}
