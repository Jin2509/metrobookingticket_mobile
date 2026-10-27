import 'dart:ui';

import 'package:metro_mobile/design_system/models/line_badge_data.dart';
import 'package:metro_mobile/design_system/models/network_diagram_models.dart';

enum DiagramLabelSide { left, right, below, above }

/// Ga đã đặt vị trí trên canvas.
class DiagramNode {
  const DiagramNode({
    required this.station,
    required this.pos,
    required this.side,
    required this.lines,
    this.terminal = false,
  });

  final DiagramStationData station;
  final Offset pos;
  final DiagramLabelSide side;
  final List<LineBadgeData> lines;
  final bool terminal;

  bool get interchange => lines.length > 1;
  bool get planned => lines.every((l) => l.planned);
}

/// Đoạn vẽ của một tuyến (hub → đầu tuyến).
class DiagramPath {
  const DiagramPath(this.line, this.points);
  final LineBadgeData line;
  final List<Offset> points;
}

class NetworkLayout {
  const NetworkLayout({
    required this.height,
    required this.nodes,
    required this.paths,
    required this.labelWidth,
  });

  static const empty = NetworkLayout(
    height: 0,
    nodes: [],
    paths: [],
    labelWidth: 0,
  );

  final double height;
  final List<DiagramNode> nodes;
  final List<DiagramPath> paths;

  /// Bề rộng tối đa của nhãn ga hai bên.
  final double labelWidth;
}
