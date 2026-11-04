import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/forecast/domain/entities/station_forecast.dart';
import 'package:metro_mobile/features/forecast/domain/repositories/forecast_repository.dart';

typedef _Json = Map<String, Object?>;

/// Backend chưa có các endpoint này. Đây là hợp đồng đề xuất để hai bên thống
/// nhất; khi đổi cách tính (quy tắc, thống kê, ML) app không phải sửa.
class ForecastRemoteSource implements ForecastRepository {
  const ForecastRemoteSource(this._dio);
  final Dio _dio;

  static int _hour(Object? v) => int.parse('$v'.split(':').first);

  @override
  Future<StationForecast> getStationForecast(
    String stationId,
    DateTime at,
  ) async {
    try {
      final res = await _dio.get<_Json>(
        '/api/stations/$stationId/forecast',
        queryParameters: {'date': at.toIso8601String().substring(0, 10)},
      );
      final j = res.data!;
      return StationForecast(
        stationId: stationId,
        source: j['source'] as String? ?? 'RULE',
        crowdByHour: {
          for (final c in j['crowd']! as List)
            ((c as _Json)['hour']! as num).toInt(): ForecastLevel.parse(
              c['level'] as String?,
            ),
        },
        road: ForecastLevel.parse(
          (j['roadTraffic'] as _Json?)?['level'] as String?,
        ),
        peaks: [
          for (final p in j['peakWindows'] as List? ?? const <dynamic>[])
            PeakWindow(_hour((p as _Json)['from']), _hour(p['to'])),
        ],
      );
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<Map<String, ForecastLevel>> getNetworkCrowd(DateTime at) async {
    try {
      final res = await _dio.get<List<dynamic>>('/api/stations/forecast/now');
      return {
        for (final s in res.data ?? const <dynamic>[])
          (s as _Json)['stationId']! as String: ForecastLevel.parse(
            s['level'] as String?,
          ),
      };
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
