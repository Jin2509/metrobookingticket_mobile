import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/forecast/presentation/widgets/station_forecast_line.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_impact_card.dart';
import 'package:metro_mobile/features/home/presentation/controllers/quick_book_controller.dart';
import 'package:metro_mobile/features/home/presentation/widgets/active_passes_section.dart';
import 'package:metro_mobile/features/home/presentation/widgets/home_banner_carousel.dart';
import 'package:metro_mobile/features/home/presentation/widgets/home_hero.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/arrivals_card.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/prefs_controller.dart';
import 'package:metro_mobile/features/notifications/presentation/widgets/news_carousel.dart';
import 'package:metro_mobile/features/notifications/presentation/widgets/operation_notice_card.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P10. Trang chủ Passenger theo mức ưu tiên: tìm ga, mua vé, bản đồ, sơ đồ
/// tuyến; thông báo vận hành; vé của tôi; hành trình xanh (gồm CPoint); tàu sắp
/// đến; banner; tin tức.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fromId = ref.watch(quickBookProvider.select((s) => s.fromId));
    final catalog = ref.watch(catalogProvider).value;
    final station = fromId == null ? null : catalog?.station(fromId);
    final hasNotice = ref.watch(
      newsProvider.select((n) => n.value?.any((e) => e.operational) ?? false),
    );
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(newsProvider);
          refreshWallet(ref);
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: MetroSpacing.fabClearance),
          children: [
            const HomeHero(),
            MetroSpacing.gapMd,
            // Từng khối là con của ListView để vẫn dựng lười khi cuộn.
            for (final section in [
              if (hasNotice) const OperationNoticeCard(),
              const ActivePassesSection(),
              const GreenImpactCard(),
              if (station != null && station.active)
                ArrivalsCard(
                  stationId: station.id,
                  catalog: catalog!,
                  title: context.l10n.arrivalsAtStation(station.name),
                  footer: StationForecastLine(stationId: station.id),
                ),
              const HomeBannerCarousel(),
              const NewsCarousel(),
            ])
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  MetroSpacing.md,
                  0,
                  MetroSpacing.md,
                  MetroSpacing.md,
                ),
                child: section,
              ),
          ],
        ),
      ),
    );
  }
}
