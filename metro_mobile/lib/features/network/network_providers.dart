import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/network/data/repositories/network_repository_impl.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_source.dart';
import 'package:metro_mobile/features/network/data/sources/network_remote_source.dart';
import 'package:metro_mobile/features/network/data/sources/network_source.dart';
import 'package:metro_mobile/features/network/domain/repositories/network_repository.dart';
import 'package:metro_mobile/features/network/domain/usecases/find_nearest_stations.dart';
import 'package:metro_mobile/features/network/domain/usecases/get_catalog.dart';
import 'package:metro_mobile/features/network/domain/usecases/get_station_detail.dart';
import 'package:metro_mobile/features/network/domain/usecases/search_route.dart';

final networkSourceProvider = Provider<NetworkSource>(
  (ref) => Env.useFakeData
      ? NetworkFakeSource()
      : NetworkRemoteSource(ref.watch(dioProvider)),
);

final networkRepositoryProvider = Provider<NetworkRepository>(
  (ref) => NetworkRepositoryImpl(ref.watch(networkSourceProvider)),
);

final getCatalogProvider = Provider(
  (ref) => GetCatalog(ref.watch(networkRepositoryProvider)),
);
final getStationDetailProvider = Provider(
  (ref) => GetStationDetail(ref.watch(networkRepositoryProvider)),
);
final findNearestProvider = Provider(
  (ref) => FindNearestStations(ref.watch(networkRepositoryProvider)),
);
final searchRouteProvider = Provider(
  (ref) => SearchRoute(ref.watch(networkRepositoryProvider)),
);

/// Tắt tile OSM trong test (không gọi mạng).
final mapTilesEnabledProvider = Provider<bool>((_) => true);
