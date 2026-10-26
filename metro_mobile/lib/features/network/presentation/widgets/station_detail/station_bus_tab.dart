import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/bus_route_chips.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Tab Xe buýt: trạm quanh ga, thời gian đi bộ, số hiệu tuyến buýt.
class StationBusTab extends StatelessWidget {
  const StationBusTab({required this.busStops, super.key});

  final List<BusStop> busStops;

  @override
  Widget build(BuildContext context) {
    final bus = context.metro.bus;
    if (busStops.isEmpty) {
      return EmptyState(icon: LucideIcons.bus, title: context.l10n.noBusStops);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final b in busStops)
          Padding(
            padding: const EdgeInsets.only(bottom: MetroSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(LucideIcons.bus, color: bus),
                MetroSpacing.gapSm,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.name, style: context.text.bodyLarge),
                      Text(
                        context.l10n.walkMinutes(b.walkMinutes),
                        style: context.text.bodySmall,
                      ),
                      MetroSpacing.gapXxs,
                      BusRouteChips(routes: b.routes),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
