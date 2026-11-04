import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/features/forecast/data/sources/forecast_fake_source.dart';
import 'package:metro_mobile/features/forecast/data/sources/forecast_remote_source.dart';
import 'package:metro_mobile/features/forecast/domain/entities/station_forecast.dart';
import 'package:metro_mobile/features/forecast/domain/repositories/forecast_repository.dart';

final forecastRepositoryProvider = Provider<ForecastRepository>(
  (ref) => Env.useFakeData
      ? const ForecastFakeSource()
      : ForecastRemoteSource(ref.watch(dioProvider)),
);

/// Giờ hiện tại theo múi giờ Việt Nam, dùng cho mọi phép so sánh giờ đông.
DateTime forecastNow() => toVnTime(clock.now());

final stationForecastProvider = FutureProvider.autoDispose
    .family<StationForecast, String>(
      (ref, stationId) => ref
          .watch(forecastRepositoryProvider)
          .getStationForecast(stationId, forecastNow()),
    );

final networkCrowdProvider =
    FutureProvider.autoDispose<Map<String, ForecastLevel>>(
      (ref) =>
          ref.watch(forecastRepositoryProvider).getNetworkCrowd(forecastNow()),
    );
