import 'package:flutter/foundation.dart';
import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';

/// Danh mục tuyến + ga, cache cả phiên (mục 9: ETag).
@immutable
class NetworkCatalog {
  NetworkCatalog({required this.lines, required List<Station> stations})
    : stations = {for (final s in stations) s.id: s};

  final List<MetroLine> lines;
  final Map<String, Station> stations;

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
}
