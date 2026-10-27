import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/home/presentation/controllers/quick_book_controller.dart';
import 'package:metro_mobile/features/home/presentation/widgets/active_passes_section.dart';
import 'package:metro_mobile/features/home/presentation/widgets/home_header.dart';
import 'package:metro_mobile/features/home/presentation/widgets/home_quick_actions.dart';
import 'package:metro_mobile/features/home/presentation/widgets/quick_book_card.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/arrivals_card.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/prefs_controller.dart';
import 'package:metro_mobile/features/notifications/presentation/widgets/news_carousel.dart';
import 'package:metro_mobile/features/notifications/presentation/widgets/operation_notice_card.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P10. Trang chủ Passenger: đặt vé nhanh, lối tắt, vé đang hiệu lực,
/// thông báo vận hành, tàu sắp đến, tin tức.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fromId = ref.watch(quickBookProvider.select((s) => s.fromId));
    final catalog = ref.watch(catalogProvider).value;
    final station = fromId == null ? null : catalog?.station(fromId);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(newsProvider);
            refreshWallet(ref);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              MetroSpacing.md,
              MetroSpacing.md,
              MetroSpacing.md,
              MetroSpacing.fabClearance,
            ),
            children: [
              const HomeHeader(),
              MetroSpacing.gapMd,
              const QuickBookCard(),
              MetroSpacing.gapSm,
              const HomeQuickActions(),
              MetroSpacing.gapLg,
              const ActivePassesSection(),
              MetroSpacing.gapMd,
              const OperationNoticeCard(),
              if (station != null && station.active) ...[
                MetroSpacing.gapLg,
                ArrivalsCard(
                  stationId: station.id,
                  catalog: catalog!,
                  title: context.l10n.arrivalsAtStation(station.name),
                ),
              ],
              MetroSpacing.gapLg,
              const NewsCarousel(),
            ],
          ),
        ),
      ),
    );
  }
}
