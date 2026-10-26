import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/arrivals_card.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/station_actions_bar.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/station_info_card.dart';
import 'package:metro_mobile/features/network/presentation/widgets/station_detail/station_info_tabs.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P22. Chi tiết ga: thông tin, tàu sắp đến, quanh ga, xe buýt.
class StationDetailScreen extends ConsumerWidget {
  const StationDetailScreen({required this.stationId, super.key});

  final String stationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(stationDetailProvider(stationId));
    final catalog = ref.watch(catalogProvider).value;
    final name = detail.value?.station.name;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name == null
              ? context.l10n.stationDetailTitle
              : context.l10n.stationName(name),
        ),
      ),
      bottomNavigationBar: detail.hasValue && detail.requireValue.station.active
          ? StationActionsBar(stationId: stationId)
          : null,
      body: AsyncValueView(
        value: detail,
        onRetry: () => ref.invalidate(stationDetailProvider(stationId)),
        data: (d) => catalog == null
            ? const SizedBox.shrink()
            : ListView(
                padding: const EdgeInsets.all(MetroSpacing.md),
                children: [
                  StationInfoCard(station: d.station, catalog: catalog),
                  if (d.station.active) ...[
                    MetroSpacing.gapMd,
                    ArrivalsCard(stationId: stationId, catalog: catalog),
                  ],
                  MetroSpacing.gapMd,
                  StationInfoTabs(detail: d, catalog: catalog),
                ],
              ),
      ),
    );
  }
}
