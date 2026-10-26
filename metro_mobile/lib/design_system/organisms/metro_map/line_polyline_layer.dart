import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:metro_mobile/design_system/models/map_models.dart';

/// Polyline theo màu tuyến; tuyến quy hoạch vẽ nét đứt.
class LinePolylineLayer extends StatelessWidget {
  const LinePolylineLayer({required this.lines, super.key});

  final List<MapLineData> lines;

  @override
  Widget build(BuildContext context) {
    return PolylineLayer(
      polylines: [
        for (final l in lines)
          Polyline(
            points: l.points,
            color: l.color,
            strokeWidth: 5,
            borderColor: const Color(0xFFFFFFFF),
            borderStrokeWidth: 1.5,
            pattern: l.planned
                ? StrokePattern.dashed(segments: const [12, 8])
                : const StrokePattern.solid(),
          ),
      ],
    );
  }
}
