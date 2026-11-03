import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/map_panel_controller.dart';
import 'package:metro_mobile/features/network/presentation/controllers/nearby_controller.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/places/nearby_places_view.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Ngăn Quanh ga: mặc định ga đang chọn, rồi tới ga gần nhất, rồi ga đầu tuyến.
class MapPlacesPanel extends ConsumerWidget {
  const MapPlacesPanel({super.key});

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final catalog = await ref.read(catalogProvider.future);
    if (!context.mounted) return;
    final picked = await StationPickerSheet.show(
      context,
      title: context.l10n.chooseStation,
      stations: catalog.options,
    );
    if (picked != null) {
      ref.read(mapPanelProvider.notifier).selectStation(picked.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider).value;
    final nearest = ref.watch(
      nearbyControllerProvider.select((s) => s.stations.firstOrNull),
    );
    final id =
        ref.watch(mapPanelProvider.select((s) => s.stationId)) ??
        nearest?.station.id ??
        catalog?.stations.values.where((s) => s.active).firstOrNull?.id;
    return Padding(
      padding: MetroSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: StationField(
                  label: context.l10n.stationShort,
                  value: id == null ? null : catalog?.station(id)?.name,
                  dotColor: context.colors.primary,
                  onTap: () => _pick(context, ref),
                ),
              ),
              if (id != null)
                TextButton(
                  onPressed: () => context.push(Routes.stationDetail(id)),
                  child: Text(context.l10n.details),
                ),
            ],
          ),
          MetroSpacing.gapSm,
          if (id != null)
            AsyncValueView(
              value: ref.watch(stationDetailProvider(id)),
              onRetry: () => ref.invalidate(stationDetailProvider(id)),
              data: (d) => NearbyPlacesView(detail: d),
            ),
        ],
      ),
    );
  }
}
