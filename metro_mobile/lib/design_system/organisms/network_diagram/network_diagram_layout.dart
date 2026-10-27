import 'dart:math' as math;
import 'dart:ui';

import 'package:metro_mobile/design_system/models/line_badge_data.dart';
import 'package:metro_mobile/design_system/models/network_diagram_models.dart';
import 'package:metro_mobile/design_system/organisms/network_diagram/network_layout_hub.dart';
import 'package:metro_mobile/design_system/organisms/network_diagram/network_layout_types.dart';

class _Branch {
  _Branch(this.line, this.stations, {required this.up, required this.right});
  final LineBadgeData line;
  final List<DiagramStationData> stations;
  bool up;
  bool right;
}

/// Bố cục sơ đồ dọc cho màn hình đứng: ga chung nhiều tuyến nhất (VD
/// Bến Thành) làm tâm; mỗi nhánh đi chéo một bước rồi thẳng đứng,
/// hướng lên/xuống, trái/phải theo vị trí địa lý của ga cuối. Tối đa 4
/// nhánh quanh tâm; tuyến không qua tâm xếp thành cột riêng bên dưới.
NetworkLayout layoutNetwork(
  List<NetworkDiagramLine> lines, {
  required double width,
  double row = 48,
  double col = 32,
  double pad = 24,
  double hubLabel = 28,
}) {
  final found = findHub(lines);
  if (found == null) return NetworkLayout.empty;
  final (:hub, :linesOf) = found;

  final branches = <_Branch>[];
  final detached = <NetworkDiagramLine>[];
  for (final l in lines) {
    final h = l.stations.indexWhere((s) => s.id == hub.id);
    if (h < 0) {
      detached.add(l);
      continue;
    }
    for (final part in [
      l.stations.sublist(h + 1),
      l.stations.sublist(0, h).reversed.toList(),
    ]) {
      if (part.isEmpty) continue;
      final end = part.last;
      final dx = (end.lng - hub.lng) * math.cos(hub.lat * math.pi / 180);
      branches.add(
        _Branch(l.line, part, up: end.lat >= hub.lat, right: dx >= 0),
      );
    }
  }
  // Mỗi góc (trên/dưới × trái/phải) chỉ một nhánh.
  final taken = <(bool, bool)>{};
  final placed = <_Branch>[];
  for (final b in branches) {
    final options = [
      (b.up, b.right),
      (b.up, !b.right),
      (!b.up, b.right),
      (!b.up, !b.right),
    ];
    final slot = options.where((o) => !taken.contains(o)).firstOrNull;
    if (slot == null) {
      detached.add(NetworkDiagramLine(line: b.line, stations: b.stations));
      continue;
    }
    taken.add(slot);
    placed.add(
      b
        ..up = slot.$1
        ..right = slot.$2,
    );
  }

  var upLen = 0;
  var downLen = 0;
  for (final b in placed) {
    b.up
        ? upLen = math.max(upLen, b.stations.length)
        : downLen = math.max(downLen, b.stations.length);
  }
  final hubSide = upLen == 0
      ? DiagramLabelSide.above
      : downLen == 0
      ? DiagramLabelSide.below
      : DiagramLabelSide.right;
  final cx = width / 2;
  final hubY =
      pad + upLen * row + (hubSide == DiagramLabelSide.above ? hubLabel : 0);
  final hubPos = Offset(cx, hubY);
  final nodes = <DiagramNode>[
    DiagramNode(
      station: hub,
      pos: hubPos,
      side: hubSide,
      lines: linesOf[hub.id]!,
    ),
  ];
  final paths = <DiagramPath>[];
  for (final b in placed) {
    final sx = b.right ? 1.0 : -1.0;
    final sy = b.up ? -1.0 : 1.0;
    final pts = [hubPos];
    for (var k = 0; k < b.stations.length; k++) {
      final p = Offset(cx + sx * col, hubY + sy * (k + 1) * row);
      pts.add(p);
      final s = b.stations[k];
      nodes.add(
        DiagramNode(
          station: s,
          pos: p,
          side: b.right ? DiagramLabelSide.right : DiagramLabelSide.left,
          lines: linesOf[s.id]!,
          terminal: k == b.stations.length - 1,
        ),
      );
    }
    paths.add(DiagramPath(b.line, pts));
  }

  var y =
      hubY + downLen * row + (hubSide == DiagramLabelSide.below ? hubLabel : 0);
  for (final l in detached) {
    final pts = <Offset>[];
    y += row;
    for (var k = 0; k < l.stations.length; k++, y += row) {
      final p = Offset(pad + 12, y);
      pts.add(p);
      nodes.add(
        DiagramNode(
          station: l.stations[k],
          pos: p,
          side: DiagramLabelSide.right,
          lines: linesOf[l.stations[k].id]!,
          terminal: k == 0 || k == l.stations.length - 1,
        ),
      );
    }
    y -= row;
    paths.add(DiagramPath(l.line, pts));
  }
  return NetworkLayout(
    height: y + pad,
    nodes: nodes,
    paths: paths,
    labelWidth: math.max(64, width / 2 - col - 20),
  );
}
