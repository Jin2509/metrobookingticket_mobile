import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/loyalty/domain/entities/loyalty.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `HẠNG BẠC ─── 820 điểm` + tiến độ lên hạng (gradient primary→sidebar).
class TierCard extends StatelessWidget {
  const TierCard({required this.summary, super.key});

  final MemberSummary summary;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    const fg = MetroColors.primaryForeground;
    return Container(
      padding: const EdgeInsets.all(MetroSpacing.md),
      decoration: BoxDecoration(
        borderRadius: MetroRadius.brXl,
        gradient: LinearGradient(
          colors: [context.colors.primary, context.metro.sidebar],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.tierTitle(s.tierName).toUpperCase(),
                  style: context.text.titleMedium?.copyWith(color: fg),
                ),
              ),
              Text(
                context.l10n.points(count(s.points)),
                style: context.text.headlineSmall?.copyWith(color: fg),
              ),
            ],
          ),
          MetroSpacing.gapSm,
          ClipRRect(
            borderRadius: MetroRadius.brPill,
            child: LinearProgressIndicator(
              value: s.progress,
              minHeight: 8,
              color: context.metro.accent,
              backgroundColor: fg.withValues(alpha: .25),
            ),
          ),
          MetroSpacing.gapXs,
          Text(
            s.nextTierName == null
                ? context.l10n.topTier
                : context.l10n.pointsToNext(
                    count(s.pointsToNext),
                    s.nextTierName!,
                  ),
            style: context.text.bodySmall?.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
