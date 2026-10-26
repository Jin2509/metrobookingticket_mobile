import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/models/map_models.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Marker tàu realtime. Vị trí đã được nội suy ở controller (1s/lần).
class LiveTrainLayer extends StatelessWidget {
  const LiveTrainLayer({required this.trains, super.key});

  final List<MapTrainData> trains;

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        for (final t in trains)
          Marker(
            key: ValueKey(t.id),
            point: t.point,
            width: 26,
            height: 26,
            child: Semantics(
              label: context.l10n.trainLabel(t.id),
              child: Container(
                decoration: BoxDecoration(
                  color: t.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(blurRadius: 4, color: Color(0x33000000)),
                  ],
                ),
                child: const Icon(
                  LucideIcons.trainFront,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
