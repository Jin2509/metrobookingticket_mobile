import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/loyalty/loyalty_providers.dart';
import 'package:metro_mobile/features/loyalty/presentation/widgets/points_history_list.dart';
import 'package:metro_mobile/features/loyalty/presentation/widgets/promotion_tile.dart';
import 'package:metro_mobile/features/loyalty/presentation/widgets/tier_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P53. Thành viên & ưu đãi (UC11).
class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promos = ref.watch(promotionsProvider).value ?? const [];
    final history = ref.watch(pointsHistoryProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.membership)),
      body: AsyncValueView(
        value: ref.watch(memberSummaryProvider),
        onRetry: () => ref.invalidate(memberSummaryProvider),
        data: (s) => ListView(
          padding: const EdgeInsets.all(MetroSpacing.md),
          children: [
            TierCard(summary: s),
            MetroSpacing.gapMd,
            SectionCard(
              title: context.l10n.tierBenefits(s.tierName),
              child: Column(
                children: [
                  for (final b in s.benefits)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        LucideIcons.check,
                        color: context.metro.success,
                      ),
                      title: Text(b, style: context.text.bodyMedium),
                    ),
                ],
              ),
            ),
            MetroSpacing.gapMd,
            SectionCard(
              title: context.l10n.activePromotions,
              child: promos.isEmpty
                  ? Text(
                      context.l10n.noPromotions,
                      style: context.text.bodySmall,
                    )
                  : Column(
                      children: [
                        for (final p in promos) PromotionTile(promotion: p),
                      ],
                    ),
            ),
            MetroSpacing.gapMd,
            SectionCard(
              title: context.l10n.pointsHistory,
              child: PointsHistoryList(entries: history),
            ),
          ],
        ),
      ),
    );
  }
}
