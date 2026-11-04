import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/features/loyalty/loyalty_providers.dart';
import 'package:metro_mobile/features/loyalty/presentation/widgets/promotion_tile.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thang giảm giá theo CPoint và các ưu đãi đang chạy.
class GreenOffersCard extends ConsumerWidget {
  const GreenOffersCard({required this.current, super.key});

  final GreenTier current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final promos = ref.watch(promotionsProvider).value ?? const [];
    return SectionCard(
      title: l.cpointScaleTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final t in GreenTier.values)
            _ScaleRow(tier: t, active: t == current),
          MetroSpacing.gapXs,
          Text(l.cpointRule(cpointPerKg), style: context.text.bodySmall),
          if (promos.isNotEmpty) ...[
            const Divider(height: MetroSpacing.lg),
            Text(l.activePromotions, style: context.text.titleSmall),
            MetroSpacing.gapXxs,
            for (final p in promos) PromotionTile(promotion: p),
          ],
        ],
      ),
    );
  }
}

class _ScaleRow extends StatelessWidget {
  const _ScaleRow({required this.tier, required this.active});

  final GreenTier tier;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final m = context.metro;
    final percent = tier.discountPercent;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: active ? m.success.withValues(alpha: .12) : null,
        borderRadius: MetroRadius.brMd,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: MetroSpacing.xs,
          vertical: MetroSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(
              greenTierIcon(tier),
              size: 20,
              color: active ? m.success : m.mutedForeground,
            ),
            MetroSpacing.gapXs,
            Expanded(
              child: Text(
                greenTierLabel(l, tier),
                style: active
                    ? context.text.titleSmall
                    : context.text.bodyMedium,
              ),
            ),
            Text(
              l.cpointAmount(count(tier.fromCpoint)),
              style: context.text.bodySmall,
            ),
            SizedBox(
              width: 56,
              child: Text(
                percent == 0 ? '–' : '-$percent%',
                textAlign: TextAlign.end,
                style: context.text.titleSmall?.copyWith(
                  color: active ? m.success : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
