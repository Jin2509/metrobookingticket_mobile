import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/presentation/widgets/places/nearby_places_view.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/station_overview_tab.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `[Tổng quan][Quanh ga]`, nội dung cuộn chung với màn. Quanh ga gồm
/// cả trạm xe buýt.
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
  late final _tabs = TabController(length: 2, vsync: this)
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
            ],
          ),
          MetroSpacing.gapSm,
          if (_tabs.index == 0)
            StationOverviewTab(detail: d, catalog: widget.catalog)
          else
            NearbyPlacesView(detail: d),
        ],
      ),
    );
  }
}
