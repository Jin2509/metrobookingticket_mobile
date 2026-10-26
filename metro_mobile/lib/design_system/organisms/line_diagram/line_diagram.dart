import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/models/diagram_stop.dart';
import 'package:metro_mobile/design_system/organisms/line_diagram/line_diagram_station_row.dart';

/// Sơ đồ tuyến dọc dạng timeline (P21, P26). Màu lấy từ từng
/// `DiagramStop` nên vẽ được lộ trình nhiều tuyến.
class LineDiagram extends StatelessWidget {
  const LineDiagram({required this.stops, this.onTapStop, super.key});

  final List<DiagramStop> stops;
  final ValueChanged<String>? onTapStop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < stops.length; i++)
          LineDiagramStationRow(
            stop: stops[i],
            previous: i == 0 ? null : stops[i - 1],
            isLast: i == stops.length - 1,
            onTap: onTapStop == null ? null : () => onTapStop!(stops[i].id),
          ),
      ],
    );
  }
}
