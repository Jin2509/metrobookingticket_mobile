import 'package:metro_mobile/core/utils/hex_color.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/live_trains/domain/entities/train_position.dart';
import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/presentation/mappers/station_labels.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P21: toàn bộ ga của tuyến, đánh dấu ga có tàu đang tới.
List<DiagramStop> lineDiagramStops(
  AppLocalizations l10n,
  NetworkCatalog catalog,
  MetroLine line, {
  List<TrainPosition> trains = const [],
}) {
  final color = colorFromHex(line.colorHex);
  final approaching = {for (final t in trains) t.nextStationId};
  return [
    for (final s in catalog.stationsOf(line))
      DiagramStop(
        id: s.id,
        name: s.name,
        color: color,
        dashed: line.isPlanned,
        interchange: s.isInterchange,
        trailing: stationStructureLabel(l10n, s.structure),
        trainApproaching: approaching.contains(s.id),
        subtitle: s.isInterchange
            ? [
                for (final l in catalog.linesOf(s))
                  if (l.id != line.id) l10n.transferTo(l.code),
              ].join(' · ')
            : null,
      ),
  ];
}

/// P26: lộ trình rút gọn – ga đầu, ga chuyển tuyến, ga cuối và số ga
/// ở giữa mỗi chặng.
List<DiagramStop> routeDiagramStops(
  AppLocalizations l10n,
  NetworkCatalog catalog,
  RoutePlan plan,
) {
  final stops = <DiagramStop>[];
  for (var i = 0; i < plan.legs.length; i++) {
    final leg = plan.legs[i];
    final line = catalog.line(leg.lineId);
    final color = colorFromHex(line?.colorHex ?? '');
    final start = catalog.station(leg.stationIds.first);
    final isFirst = i == 0;
    stops.add(
      DiagramStop(
        id: leg.stationIds.first,
        name: start?.name ?? leg.stationIds.first,
        color: color,
        interchange: !isFirst,
        highlighted: isFirst,
        subtitle: isFirst
            ? '${line?.code} · ${l10n.stationCount(leg.hops)}'
            : l10n.changeTo(line?.code ?? ''),
      ),
    );
    if (leg.hops > 1) {
      stops.add(DiagramStop.collapsed(count: leg.hops - 1, color: color));
    }
  }
  final last = catalog.station(plan.toId);
  stops.add(
    DiagramStop(
      id: plan.toId,
      name: last?.name ?? plan.toId,
      color: stops.last.color,
      highlighted: true,
    ),
  );
  return stops;
}
