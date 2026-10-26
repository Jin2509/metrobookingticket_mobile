import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:metro_mobile/design_system/models/map_models.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Marker ga: chấm tròn viền màu tuyến, ga chuyển tuyến lớn hơn.
class StationMarkerLayer extends StatelessWidget {
  const StationMarkerLayer({
    required this.stations,
    this.highlightedId,
    this.onTap,
    super.key,
  });

  final List<MapStationData> stations;
  final String? highlightedId;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        for (final s in stations)
          Marker(
            point: s.point,
            // Chấm nhỏ nhưng vùng chạm 48dp.
            width: 48,
            height: 48,
            child: Semantics(
              button: true,
              label: context.l10n.stationName(s.name),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap == null ? null : () => onTap!(s.id),
                child: Center(
                  child: _Dot(station: s, highlighted: s.id == highlightedId),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.station, required this.highlighted});
  final MapStationData station;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final size = station.interchange || highlighted ? 18.0 : 13.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: highlighted ? station.color : const Color(0xFFFFFFFF),
        shape: BoxShape.circle,
        border: Border.all(
          color: station.active
              ? station.color
              : station.color.withValues(alpha: .5),
          width: station.interchange ? 4 : 3,
        ),
      ),
    );
  }
}
