import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/controllers/green_controller.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_calculator_card.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_impact_card.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_method_card.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_share_sheet.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_stat.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Hành trình xanh: số tổng, ba chỉ số, so sánh quãng đường, cách tính.
class GreenImpactScreen extends ConsumerWidget {
  const GreenImpactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = context.metro;
    final s =
        ref.watch(greenSummaryProvider).value ??
        const GreenSummary(trips: 0, km: 0);
    final hasTrips = s.trips > 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.greenTitle),
        actions: [
          if (hasTrips)
            IconButton(
              tooltip: l.greenShare,
              icon: const Icon(LucideIcons.share2),
              onPressed: () => GreenShareSheet.show(context, s),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(MetroSpacing.md),
        children: [
          MetroCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  hasTrips
                      ? l.greenSavedKg(greenNumber(s.savedKg))
                      : l.greenEmpty,
                  style: context.text.displaySmall?.copyWith(color: m.success),
                ),
                if (hasTrips) ...[
                  Text(l.greenCompared, style: context.text.bodySmall),
                  MetroSpacing.gapMd,
                  GreenTierBar(kg: s.savedKg),
                ],
              ],
            ),
          ),
          if (hasTrips) ...[
            MetroSpacing.gapSm,
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GreenStat('${s.trips}', l.greenStatTrips),
                  MetroSpacing.gapXs,
                  GreenStat(greenNumber(s.km), l.greenStatKm),
                  MetroSpacing.gapXs,
                  GreenStat(
                    treeDays(s.savedKg).round().toString(),
                    l.greenStatTreeDays,
                  ),
                ],
              ),
            ),
          ],
          MetroSpacing.gapMd,
          const GreenCalculatorCard(),
          MetroSpacing.gapMd,
          const GreenMethodCard(),
        ],
      ),
    );
  }
}
