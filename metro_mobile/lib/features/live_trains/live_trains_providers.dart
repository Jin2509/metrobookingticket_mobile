import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/live_trains/data/repositories/live_trains_repository_impl.dart';
import 'package:metro_mobile/features/live_trains/data/sources/live_trains_fake_source.dart';
import 'package:metro_mobile/features/live_trains/data/sources/live_trains_source.dart';
import 'package:metro_mobile/features/live_trains/data/sources/live_trains_stomp_source.dart';
import 'package:metro_mobile/features/live_trains/domain/repositories/live_trains_repository.dart';
import 'package:metro_mobile/features/network/network_providers.dart';

/// WS_URL rỗng → mô phỏng tàu chạy trên dữ liệu tuyến hiện có.
final liveTrainsSourceProvider = Provider<LiveTrainsSource>((ref) {
  if (Env.wsUrl.isEmpty) {
    final repo = ref.watch(networkRepositoryProvider);
    return LiveTrainsFakeSource(catalog: repo.getCatalog);
  }
  return LiveTrainsStompSource(ref.watch(stompClientProvider));
});

final liveTrainsRepositoryProvider = Provider<LiveTrainsRepository>(
  (ref) => LiveTrainsRepositoryImpl(ref.watch(liveTrainsSourceProvider)),
);
