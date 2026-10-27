import 'package:metro_mobile/core/utils/hex_color.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/live_trains/domain/entities/train_position.dart';
import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

/// Entity → model hiển thị của design system.
extension MetroLineView on MetroLine {
  LineBadgeData get badge => LineBadgeData(
    id: id,
    code: code,
    name: name,
    color: colorFromHex(colorHex),
    planned: isPlanned,
  );
}

extension CatalogView on NetworkCatalog {
  StationOption option(Station s) => StationOption(
    id: s.id,
    name: s.name,
    lines: [for (final l in linesOf(s)) l.badge],
    active: s.active,
  );

  /// Ga theo thứ tự tuyến, mỗi ga một lần (cho StationPickerSheet).
  List<StationOption> get options => [
    for (final s in stations.values) option(s),
  ];

  /// Tuyến khai thác vẽ trước để được chọn làm trục chính của sơ đồ.
  List<NetworkDiagramLine> get diagramLines => [
    for (final l in [...lines]..sort((a, b) => a.status.index - b.status.index))
      NetworkDiagramLine(
        line: l.badge,
        stations: [
          for (final s in stationsOf(l))
            DiagramStationData(id: s.id, name: s.name, lat: s.lat, lng: s.lng),
        ],
      ),
  ];

  List<MapLineData> mapLines({String? onlyLineId}) => [
    for (final l in lines)
      if (onlyLineId == null || l.id == onlyLineId)
        MapLineData(
          id: l.id,
          color: colorFromHex(l.colorHex),
          planned: l.isPlanned,
          points: [for (final s in stationsOf(l)) LatLng(s.lat, s.lng)],
        ),
  ];

  List<MapStationData> mapStations({String? onlyLineId}) => [
    for (final s in stations.values)
      if (onlyLineId == null || s.lineIds.contains(onlyLineId))
        MapStationData(
          id: s.id,
          name: s.name,
          point: LatLng(s.lat, s.lng),
          color: colorFromHex(linesOf(s).first.colorHex),
          interchange: s.isInterchange,
          active: s.active,
        ),
  ];

  List<MapTrainData> mapTrains(List<TrainPosition> trains) => [
    for (final t in trains)
      MapTrainData(
        id: t.trainId,
        point: LatLng(t.lat, t.lng),
        color: colorFromHex(line(t.lineId)?.colorHex ?? ''),
      ),
  ];
}

List<MapBusStopData> mapBusStops(List<BusStop> stops) => [
  for (final b in stops)
    MapBusStopData(id: b.id, name: b.name, point: LatLng(b.lat, b.lng)),
];
