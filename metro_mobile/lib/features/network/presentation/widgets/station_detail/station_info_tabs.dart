import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/station_amenities_tab.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/station_bus_tab.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/station_overview_tab.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `[Tổng quan][Quanh ga][Xe buýt]`, nội dung cuộn chung với màn.
class StationInfoTabs extends StatefulWidget {
  const StationInfoTabs({
    required this.detail,
    required this.catalog,
    super.key,
  });

  final StationDetail detail;
  final NetworkCatalog catalog;

  @override
  State<StationInfoTabs> createState() => _StationInfoTabsState();
}

class _StationInfoTabsState extends State<StationInfoTabs>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 3, vsync: this)
    ..addListener(() => setState(() {}));

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    return MetroCard(
      padding: const EdgeInsets.fromLTRB(
        MetroSpacing.md,
        0,
        MetroSpacing.md,
        MetroSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            controller: _tabs,
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            labelStyle: context.text.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: context.l10n.tabOverview),
              Tab(text: context.l10n.tabNearby),
              Tab(text: context.l10n.tabBus),
            ],
          ),
          MetroSpacing.gapSm,
          switch (_tabs.index) {
            0 => StationOverviewTab(detail: d, catalog: widget.catalog),
            1 => StationAmenitiesTab(amenities: d.amenities),
            _ => StationBusTab(busStops: d.busStops),
          },
        ],
      ),
    );
  }
}
