import 'package:flutter/foundation.dart';
import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';

/// Điểm chuyển tuyến có hướng tại một ga (`line_transfer`).
@immutable
class LineTransfer {
  const LineTransfer({
    required this.stationId,
    required this.fromLineId,
    required this.toLineId,
    required this.minutes,
    this.active = true,
  });

  final String stationId;
  final String fromLineId;
  final String toLineId;
  final int minutes;
  final bool active;
}

/// Danh mục tuyến + ga, cache cả phiên (mục 9: ETag).
@immutable
class NetworkCatalog {
  NetworkCatalog({
    required this.lines,
    required List<Station> stations,
    this.transfers = const [],
  }) : stations = {for (final s in stations) s.id: s};

  final List<MetroLine> lines;
  final Map<String, Station> stations;
  final List<LineTransfer> transfers;

  MetroLine? line(String id) {
    for (final l in lines) {
      if (l.id == id) return l;
    }
    return null;
  }

  Station? station(String id) => stations[id];

  /// Ga của tuyến theo đúng `station_order`.
  List<Station> stationsOf(MetroLine line) => [
    for (final id in line.stationIds) ?stations[id],
  ];

  List<MetroLine> linesOf(Station s) => [for (final id in s.lineIds) ?line(id)];

  /// Cấu hình chuyển tuyến tại [stationId] theo chiều [from] → [to].
  LineTransfer? transfer(String stationId, String from, String to) {
    for (final t in transfers) {
      if (t.stationId == stationId &&
          t.fromLineId == from &&
          t.toLineId == to) {
        return t;
      }
    }
    return null;
  }
}
