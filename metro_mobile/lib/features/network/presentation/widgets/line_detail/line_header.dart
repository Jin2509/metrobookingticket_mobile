import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `(Hoạt động) 19,7 km · 14 ga` + `05:00–22:00 · 8–10 phút/chuyến`.
class LineHeader extends StatelessWidget {
  const LineHeader({required this.line, this.live, super.key});

  final MetroLine line;

  /// Chip trạng thái realtime (chỉ tuyến đang khai thác).
  final Widget? live;

  @override
  Widget build(BuildContext context) {
    final km = line.lengthKm?.toString().replaceAll('.', ',');
    final schedule = [?line.operatingHours, ?line.headway];
    return MetroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: MetroSpacing.xs,
            runSpacing: MetroSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StatusBadge(
                status: line.isPlanned ? 'INACTIVE' : 'ACTIVE',
                label: line.isPlanned
                    ? context.l10n.linePlanned
                    : context.l10n.statusActive,
              ),
              Text(
                [
                  if (km != null) '$km km',
                  context.l10n.stationCount(line.stationIds.length),
                ].join(' · '),
                style: context.text.bodyMedium,
              ),
              ?live,
            ],
          ),
          if (schedule.isNotEmpty) ...[
            MetroSpacing.gapXs,
            Row(
              children: [
                Icon(
                  LucideIcons.clock,
                  size: 14,
                  color: context.metro.mutedForeground,
                ),
                MetroSpacing.gapXxs,
                Expanded(
                  child: Text(
                    schedule.join(' · '),
                    style: context.text.bodySmall,
                  ),
                ),
              ],
            ),
          ],
          if (line.isPlanned) ...[
            MetroSpacing.gapXs,
            Text(context.l10n.linePlannedNote, style: context.text.bodySmall),
          ],
        ],
      ),
    );
  }
}
