import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/models/map_models.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Trạm xe buýt (màu `bus`).
class BusStopLayer extends StatelessWidget {
  const BusStopLayer({required this.stops, super.key});

  final List<MapBusStopData> stops;

  @override
  Widget build(BuildContext context) {
    final bus = context.metro.bus;
    return MarkerLayer(
      markers: [
        for (final s in stops)
          Marker(
            point: s.point,
            width: 22,
            height: 22,
            child: Semantics(
              label: context.l10n.busStopLabel(s.name),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: bus,
                  borderRadius: MetroRadius.brSm,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Icon(
                  LucideIcons.bus,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
