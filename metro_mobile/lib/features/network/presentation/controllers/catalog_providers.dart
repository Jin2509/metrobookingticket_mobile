import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/network_providers.dart';

/// Danh mục tuyến + ga, giữ suốt phiên (cache, mục 10.2).
final catalogProvider = FutureProvider<NetworkCatalog>(
  (ref) => ref.watch(getCatalogProvider).call(),
);

/// Kéo để làm mới: bỏ cache rồi tải lại.
Future<void> refreshCatalog(WidgetRef ref) async {
  await ref.read(getCatalogProvider).call(refresh: true);
  ref.invalidate(catalogProvider);
  await ref.read(catalogProvider.future);
}

final stationDetailProvider = FutureProvider.autoDispose
    .family<StationDetail, String>(
      (ref, id) => ref.watch(getStationDetailProvider).call(id),
    );

final busStopsProvider = FutureProvider<List<BusStop>>(
  (ref) => ref.watch(networkRepositoryProvider).getBusStops(),
);
