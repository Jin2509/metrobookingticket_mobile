import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/molecules/route_label.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `12.000 ₫ · ~22 phút · 10 ga` (P10, P26).
class RouteSummaryBar extends StatelessWidget {
  const RouteSummaryBar({
    required this.fare,
    required this.minutes,
    required this.stationCount,
    this.transfers = 0,
    this.from,
    this.to,
    super.key,
  });

  final int fare;
  final int minutes;
  final int stationCount;
  final int transfers;
  final String? from;
  final String? to;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final l = context.l10n;
    final parts = [
      l.routeMinutesApprox(minutes),
      l.stationCount(stationCount),
      if (transfers > 0) l.transferCount(transfers),
    ];
    return Container(
      padding: const EdgeInsets.all(MetroSpacing.sm),
      decoration: BoxDecoration(
        color: m.secondary,
        borderRadius: MetroRadius.brMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (from != null && to != null) ...[
            RouteLabel(from: from!, to: to!, style: context.text.labelMedium),
            MetroSpacing.gapXxs,
          ],
          Row(
            children: [
              Text(
                money(fare),
                style: context.text.titleMedium?.copyWith(
                  color: context.colors.primary,
                ),
              ),
              Expanded(
                child: Text(
                  '  ·  ${parts.join('  ·  ')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
