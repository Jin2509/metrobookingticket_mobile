import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/models/station_option.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Các ga đã chọn gần đây, dạng chip ngang.
class RecentStations extends StatelessWidget {
  const RecentStations({
    required this.stations,
    required this.onSelected,
    super.key,
  });

  final List<StationOption> stations;
  final ValueChanged<StationOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Padding(
      padding: MetroSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.recent, style: context.text.labelSmall),
          MetroSpacing.gapXs,
          Wrap(
            spacing: MetroSpacing.xs,
            runSpacing: MetroSpacing.xs,
            children: [
              for (final s in stations)
                ActionChip(
                  avatar: Icon(
                    LucideIcons.history,
                    size: 16,
                    color: m.mutedForeground,
                  ),
                  label: Text(s.name),
                  labelStyle: context.text.labelMedium,
                  backgroundColor: m.muted,
                  side: BorderSide.none,
                  shape: const RoundedRectangleBorder(
                    borderRadius: MetroRadius.brPill,
                  ),
                  onPressed: s.active ? () => onSelected(s) : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
