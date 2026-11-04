import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/forecast/forecast_providers.dart';
import 'package:metro_mobile/features/forecast/presentation/widgets/forecast_format.dart';
import 'package:metro_mobile/features/network/network_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/map_filter_controller.dart';
import 'package:metro_mobile/features/network/presentation/controllers/map_panel_controller.dart';
import 'package:metro_mobile/features/network/presentation/controllers/nearby_controller.dart';
import 'package:metro_mobile/features/network/presentation/mappers/network_view_mappers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/map/live_trains_overlay.dart';

/// Ghép dữ liệu vào `MetroMapView`. Tàu realtime nằm ở `LiveTrainsOverlay`
/// để bản đồ không dựng lại mỗi giây.
class NetworkMap extends ConsumerStatefulWidget {
  const NetworkMap({this.focusStationId, super.key});

  final String? focusStationId;

  @override
  ConsumerState<NetworkMap> createState() => _NetworkMapState();
}

class _NetworkMapState extends ConsumerState<NetworkMap> {
  final _map = MapController();
  bool _focused = false;

  void _move(LatLng p, double zoom) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _map.move(p, zoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(catalogProvider).value;
    final filter = ref.watch(mapFilterProvider);
    final nearby = ref.watch(nearbyControllerProvider);
    ref.listen(nearbyControllerProvider.select((s) => s.origin), (_, o) {
      if (o != null) _move(LatLng(o.$1, o.$2), 14);
    });
    if (catalog == null) return const SizedBox.expand();

    // Chỉ lấy độ đông khi người dùng bật lớp này.
    final crowd = filter.showCrowd
        ? ref.watch(networkCrowdProvider).value
        : null;

    final focus = catalog.station(widget.focusStationId ?? '');
    if (focus != null && !_focused) {
      _focused = true;
      _move(LatLng(focus.lat, focus.lng), 15);
    }
    final origin = nearby.origin;
    return MetroMapView(
      controller: _map,
      showTiles: ref.watch(mapTilesEnabledProvider),
      lines: catalog.mapLines(onlyLineId: filter.lineId),
      stations: catalog.mapStations(
        onlyLineId: filter.lineId,
        colorOf: crowd == null
            ? null
            : (id) {
                final level = crowd[id];
                return level == null ? null : forecastColor(context, level);
              },
      ),
      busStops: filter.showBus
          ? mapBusStops(ref.watch(busStopsProvider).value ?? const [])
          : const [],
      overlays: const [LiveTrainsOverlay()],
      highlightedStationId:
          ref.watch(mapPanelProvider.select((s) => s.stationId)) ?? focus?.id,
      userLocation: origin == null ? null : LatLng(origin.$1, origin.$2),
      onStationTap: ref.read(mapPanelProvider.notifier).selectStation,
      onMapTap: nearby.status == NearbyStatus.picking
          ? (p) => ref
                .read(nearbyControllerProvider.notifier)
                .pickOnMap(p.latitude, p.longitude)
          : null,
    );
  }
}
