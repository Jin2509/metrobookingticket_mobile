import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/controllers/green_controller.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_calculator_card.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_hero.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_method_card.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_offers_card.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_share_sheet.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_stat.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Hành trình xanh: cảnh Trái Đất cùng Futu, ba chỉ số, ưu đãi theo CPoint,
/// so sánh quãng đường, cách tính.
class GreenImpactScreen extends ConsumerWidget {
  const GreenImpactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    const white = MetroColors.primaryForeground;
    final s =
        ref.watch(greenSummaryProvider).value ??
        const GreenSummary(trips: 0, km: 0);
    final hasTrips = s.trips > 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.greenTitle),
        backgroundColor: context.metro.sidebar,
        foregroundColor: white,
        titleTextStyle: context.text.titleLarge?.copyWith(color: white),
        iconTheme: const IconThemeData(color: white),
        actionsIconTheme: const IconThemeData(color: white),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
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
        padding: const EdgeInsets.only(bottom: MetroSpacing.lg),
        children: [
          GreenHero(summary: s),
          Padding(
            padding: const EdgeInsets.all(MetroSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasTrips) ...[
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
                  MetroSpacing.gapMd,
                ],
                GreenOffersCard(current: s.tier),
                MetroSpacing.gapMd,
                const GreenCalculatorCard(),
                MetroSpacing.gapMd,
                const GreenMethodCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
