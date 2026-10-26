import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/atoms/line_chip.dart';
import 'package:metro_mobile/design_system/models/station_option.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Một dòng ga: tên, tuyến, khoảng cách/ETA, cờ chuyển tuyến.
class StationTile extends StatelessWidget {
  const StationTile({
    required this.station,
    this.trailing,
    this.onTap,
    super.key,
  });

  final StationOption station;

  /// VD `350 m` hoặc `2 phút`.
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final muted = context.text.labelSmall;
    return InkWell(
      onTap: station.active ? onTap : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: MetroSpacing.minTouch),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: MetroSpacing.md,
            vertical: MetroSpacing.xs,
          ),
          child: Row(
            children: [
              Icon(
                station.isInterchange
                    ? LucideIcons.circleDot
                    : LucideIcons.circle,
                size: 18,
                color: station.lines.isEmpty
                    ? m.mutedForeground
                    : station.lines.first.color,
              ),
              MetroSpacing.gapSm,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(station.name, style: context.text.titleSmall),
                    MetroSpacing.gapXxs,
                    Wrap(
                      spacing: MetroSpacing.xxs,
                      runSpacing: MetroSpacing.xxs,
                      children: [
                        for (final l in station.lines) LineChip(line: l),
                        if (station.isInterchange)
                          Text(context.l10n.interchangeStation, style: muted),
                        if (!station.active)
                          Text(context.l10n.stationClosed, style: muted),
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) Text(trailing!, style: muted),
              if (onTap != null && station.active)
                Icon(LucideIcons.chevronRight, color: m.mutedForeground),
            ],
          ),
        ),
      ),
    );
  }
}
