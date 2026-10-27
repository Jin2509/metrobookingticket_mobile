import 'package:flutter/foundation.dart';
import 'package:metro_mobile/design_system/models/line_badge_data.dart';

/// Ga trên sơ đồ mạng lưới. Tọa độ chỉ dùng để chọn hướng nhánh.
@immutable
class DiagramStationData {
  const DiagramStationData({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
  });

  final String id;
  final String name;
  final double lat;
  final double lng;
}

/// Một tuyến trên sơ đồ: ga theo thứ tự chạy.
@immutable
class NetworkDiagramLine {
  const NetworkDiagramLine({required this.line, required this.stations});

  final LineBadgeData line;
  final List<DiagramStationData> stations;
}
