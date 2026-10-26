import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/live_trains/domain/entities/train_position.dart';
import 'package:metro_mobile/features/live_trains/domain/usecases/estimate_arrivals.dart';
import 'package:metro_mobile/features/live_trains/presentation/controllers/live_trains_controllers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';

/// Tàu sắp đến ga (P22), gộp mọi tuyến đang khai thác đi qua ga.
final stationArrivalsProvider = Provider.autoDispose
    .family<AsyncValue<List<Arrival>>, String>((ref, stationId) {
      final catalog = ref.watch(catalogProvider).value;
      final station = catalog?.station(stationId);
      if (catalog == null || station == null) return const AsyncLoading();
      final result = <Arrival>[];
      for (final line in catalog.linesOf(station)) {
        if (line.isPlanned) continue;
        final trains = ref.watch(lineTrainsProvider(line.id));
        if (!trains.hasValue) return const AsyncLoading();
        result.addAll(
          estimateArrivals(
            stationIds: line.stationIds,
            stationId: stationId,
            trains: trains.requireValue,
          ),
        );
      }
      return AsyncData(result);
    });
