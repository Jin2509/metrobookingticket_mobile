import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/features/live_trains/data/repositories/live_trains_repository_impl.dart';
import 'package:metro_mobile/features/live_trains/data/sources/live_trains_source.dart';
import 'package:metro_mobile/features/live_trains/data/sources/live_trains_ws_source.dart';
import 'package:metro_mobile/features/live_trains/domain/repositories/live_trains_repository.dart';
import 'package:metro_mobile/features/network/network_providers.dart';

final liveTrainsSourceProvider = Provider<LiveTrainsSource>(
  (ref) => LiveTrainsWsSource(
    baseUrl: LiveTrainsWsSource.resolveBase(Env.wsUrl, Env.baseUrl),
    catalog: ref.watch(networkRepositoryProvider).getCatalog,
  ),
);

final liveTrainsRepositoryProvider = Provider<LiveTrainsRepository>(
  (ref) => LiveTrainsRepositoryImpl(ref.watch(liveTrainsSourceProvider)),
);
