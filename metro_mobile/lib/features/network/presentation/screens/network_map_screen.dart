import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/widgets/line_detail/line_live_chip.dart';
import 'package:metro_mobile/features/network/presentation/widgets/map/locate_button.dart';
import 'package:metro_mobile/features/network/presentation/widgets/map/map_filter_bar.dart';
import 'package:metro_mobile/features/network/presentation/widgets/map/nearby_sheet.dart';
import 'package:metro_mobile/features/network/presentation/widgets/map/network_map.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P23 + P24. Bản đồ mạng lưới, tàu realtime, ga gần bạn.
class NetworkMapScreen extends StatelessWidget {
  const NetworkMapScreen({this.stationId, this.nearby = false, super.key});

  final String? stationId;
  final bool nearby;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.networkMapTitle)),
      body: Stack(
        children: [
          Positioned.fill(child: NetworkMap(focusStationId: stationId)),
          const Positioned(
            top: MetroSpacing.xs,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MapFilterBar(),
                MetroSpacing.gapXs,
                Padding(
                  padding: MetroSpacing.screenPadding,
                  child: LineLiveChip(),
                ),
              ],
            ),
          ),
          const Align(alignment: Alignment(.92, .3), child: LocateButton()),
          NearbySheet(autoLocate: nearby),
        ],
      ),
    );
  }
}
