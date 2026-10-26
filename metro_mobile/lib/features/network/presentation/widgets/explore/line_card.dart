import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thẻ tuyến ở P20: mã, tên, trạng thái, chiều dài, số ga, giờ chạy.
class LineCard extends StatelessWidget {
  const LineCard({required this.line, required this.onTap, super.key});

  final MetroLine line;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final facts = [
      if (line.lengthKm != null)
        '${line.lengthKm.toString().replaceAll('.', ',')} km',
      context.l10n.stationCount(line.stationIds.length),
      ?line.operatingHours,
    ];
    return MetroCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    LineChip(line: line.badge),
                    MetroSpacing.gapXs,
                    StatusBadge(
                      status: line.isPlanned ? 'INACTIVE' : 'ACTIVE',
                      label: line.isPlanned
                          ? context.l10n.linePlanned
                          : context.l10n.inService,
                    ),
                  ],
                ),
                MetroSpacing.gapXs,
                Text(line.name, style: context.text.titleMedium),
                Text(facts.join(' · '), style: context.text.bodySmall),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: context.metro.mutedForeground),
        ],
      ),
    );
  }
}
