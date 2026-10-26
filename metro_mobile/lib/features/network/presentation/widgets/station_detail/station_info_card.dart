import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/features/network/presentation/mappers/station_labels.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `(Tuyến 1)(Tuyến 2) · Ga chuyển tuyến` + địa chỉ, trạng thái, kết cấu.
class StationInfoCard extends StatelessWidget {
  const StationInfoCard({
    required this.station,
    required this.catalog,
    super.key,
  });

  final Station station;
  final NetworkCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return MetroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: MetroSpacing.xs,
            runSpacing: MetroSpacing.xxs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final l in catalog.linesOf(station)) LineChip(line: l.badge),
              if (station.isInterchange)
                Text(
                  context.l10n.interchangeStation,
                  style: context.text.labelMedium,
                ),
            ],
          ),
          MetroSpacing.gapSm,
          Row(
            children: [
              Icon(LucideIcons.mapPin, size: 14, color: m.mutedForeground),
              MetroSpacing.gapXxs,
              Expanded(
                child: Text(
                  [
                    ?station.address,
                    stationStructureLabel(context.l10n, station.structure),
                  ].join(' · '),
                  style: context.text.bodySmall,
                ),
              ),
              StatusBadge(
                status: station.active ? 'ACTIVE' : 'INACTIVE',
                label: station.active
                    ? context.l10n.inOperation
                    : context.l10n.notInOperation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
