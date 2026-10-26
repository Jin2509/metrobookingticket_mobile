import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Tab Tổng quan: tuyến đi qua ga và các lối ra.
class StationOverviewTab extends StatelessWidget {
  const StationOverviewTab({
    required this.detail,
    required this.catalog,
    super.key,
  });

  final StationDetail detail;
  final NetworkCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final l in catalog.linesOf(detail.station))
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: LineChip(line: l.badge),
            title: Text(l.name, style: context.text.bodyMedium),
            trailing: Icon(LucideIcons.chevronRight, color: m.mutedForeground),
            onTap: () => context.push(Routes.lineDetail(l.id)),
          ),
        if (detail.exits.isNotEmpty) ...[
          MetroSpacing.gapSm,
          Text(context.l10n.exits, style: context.text.labelSmall),
          for (final e in detail.exits)
            Padding(
              padding: const EdgeInsets.only(top: MetroSpacing.xs),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.doorOpen,
                    size: 16,
                    color: m.mutedForeground,
                  ),
                  MetroSpacing.gapXs,
                  Expanded(child: Text(e, style: context.text.bodyMedium)),
                ],
              ),
            ),
        ],
      ],
    );
  }
}
