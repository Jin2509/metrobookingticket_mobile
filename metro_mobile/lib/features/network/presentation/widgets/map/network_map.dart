import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/network_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/map_filter_controller.dart';
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
      stations: catalog.mapStations(onlyLineId: filter.lineId),
      busStops: filter.showBus
          ? mapBusStops(ref.watch(busStopsProvider).value ?? const [])
          : const [],
      overlays: const [LiveTrainsOverlay()],
      highlightedStationId: focus?.id,
      userLocation: origin == null ? null : LatLng(origin.$1, origin.$2),
      onStationTap: (id) => context.push(Routes.stationDetail(id)),
      onMapTap: nearby.status == NearbyStatus.picking
          ? (p) => ref
                .read(nearbyControllerProvider.notifier)
                .pickOnMap(p.latitude, p.longitude)
          : null,
    );
  }
}
