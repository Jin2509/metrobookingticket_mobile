import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/models/network_diagram_models.dart';
import 'package:metro_mobile/design_system/organisms/network_diagram/network_diagram_label.dart';
import 'package:metro_mobile/design_system/organisms/network_diagram/network_diagram_layout.dart';
import 'package:metro_mobile/design_system/organisms/network_diagram/network_diagram_painter.dart';
import 'package:metro_mobile/design_system/organisms/network_diagram/network_layout_types.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';

/// Sơ đồ mạng lưới (kiểu tube map) cho màn hình đứng. Chạm ga →
/// [onStationTap]. Mỗi ga là một nút bấm cao 48dp kèm nhãn.
class NetworkDiagram extends StatelessWidget {
  const NetworkDiagram({
    required this.lines,
    required this.onStationTap,
    this.highlightId,
    super.key,
  });

  final List<NetworkDiagramLine> lines;
  final ValueChanged<String> onStationTap;
  final String? highlightId;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return LayoutBuilder(
      builder: (context, c) {
        final layout = layoutNetwork(lines, width: c.maxWidth);
        return SizedBox(
          height: layout.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: NetworkDiagramPainter(
                    layout: layout,
                    background: m.card,
                    ink: context.colors.onSurface,
                    highlightId: highlightId,
                  ),
                ),
              ),
              for (final n in layout.nodes)
                DiagramStationLabel(
                  node: n,
                  width:
                      n.side == DiagramLabelSide.left ||
                          n.side == DiagramLabelSide.right
                      ? layout.labelWidth
                      : c.maxWidth / 2,
                  onTap: () => onStationTap(n.station.id),
                ),
            ],
          ),
        );
      },
    );
  }
}
