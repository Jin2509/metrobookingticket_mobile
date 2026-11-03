import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/controllers/green_controller.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thẻ "Hành trình xanh" ở Trang chủ: CO2 đã bớt và tiến độ cấp.
class GreenImpactCard extends ConsumerWidget {
  const GreenImpactCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = context.metro;
    final s =
        ref.watch(greenSummaryProvider).value ??
        const GreenSummary(trips: 0, km: 0);
    return MetroCard(
      onTap: () => context.push(Routes.pGreen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(LucideIcons.leaf, size: 20, color: m.success),
              MetroSpacing.gapXs,
              Expanded(
                child: Text(l.greenTitle, style: context.text.titleMedium),
              ),
              Text(
                s.trips == 0
                    ? l.greenEmpty
                    : l.greenSavedKg(greenNumber(s.savedKg)),
                style: context.text.titleMedium?.copyWith(color: m.success),
              ),
            ],
          ),
          if (s.trips > 0) ...[MetroSpacing.gapSm, GreenTierBar(kg: s.savedKg)],
        ],
      ),
    );
  }
}

/// Tên cấp, số kg so với mốc của cấp và thanh tiến độ.
class GreenTierBar extends StatelessWidget {
  const GreenTierBar({required this.kg, super.key});

  final double kg;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final m = context.metro;
    final tier = GreenTier.of(kg);
    final to = tier.toKg;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                greenTierLabel(l, tier),
                style: context.text.labelMedium,
              ),
            ),
            if (to != null)
              Text(
                l.greenTierProgress(greenNumber(kg), greenNumber(to)),
                style: context.text.labelSmall,
              ),
          ],
        ),
        MetroSpacing.gapXxs,
        ClipRRect(
          borderRadius: MetroRadius.brPill,
          child: LinearProgressIndicator(
            value: tier.progress(kg),
            minHeight: 8,
            color: m.success,
            backgroundColor: m.muted,
          ),
        ),
      ],
    );
  }
}
