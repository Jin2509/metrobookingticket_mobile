import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/geo.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/mappers/place_groups.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/bus_route_chips.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `[icon] Bệnh viện Sài Gòn / Bệnh viện · 350 m · 5 phút đi bộ`.
/// Trạm buýt có thêm số hiệu tuyến.
class NearbyPlaceTile extends StatelessWidget {
  const NearbyPlaceTile({required this.place, super.key});

  final NearbyPlace place;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = place;
    final (icon, color, title, meta) = switch (p) {
      BusPlace(:final stop) => (
        LucideIcons.bus,
        context.metro.bus,
        stop.name,
        [l.kindBusStop, l.walkMinutes(stop.walkMinutes)],
      ),
      AmenityPlace(:final amenity) => (
        amenityIcon(amenity.kind),
        context.colors.primary,
        amenity.name,
        [
          amenityKindLabel(l, amenity.kind),
          formatDistance(amenity.distanceM.toDouble()),
          l.walkMinutes(amenity.walkMinutes),
        ],
      ),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: .12),
            child: Icon(icon, size: 18, color: color),
          ),
          MetroSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.bodyLarge),
                Text(meta.join(' · '), style: context.text.bodySmall),
                if (p is BusPlace) ...[
                  MetroSpacing.gapXxs,
                  BusRouteChips(routes: p.stop.routes),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
