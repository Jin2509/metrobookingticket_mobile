import 'package:dio/dio.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/network/data/dtos/network_dtos.dart';
import 'package:metro_mobile/features/network/data/sources/network_source.dart';
import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

class NetworkRemoteSource implements NetworkSource {
  const NetworkRemoteSource(this._dio);
  final Dio _dio;

  Future<T> _get<T>(String path, {Map<String, dynamic>? query}) async {
    try {
      final res = await _dio.get<T>(path, queryParameters: query);
      return res.data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<List<MetroLine>> fetchLines() async => [
    for (final j in await _get<List<dynamic>>('/api/routes'))
      NetworkDtos.line(j as Json),
  ];

  @override
  Future<List<Station>> fetchStations() async => [
    for (final j in await _get<List<dynamic>>('/api/stations'))
      NetworkDtos.station(j as Json),
  ];

  @override
  Future<StationDetail> fetchStationDetail(String id) async =>
      NetworkDtos.detail(await _get<Json>('/api/stations/$id'));

  @override
  Future<List<NearbyStation>> fetchNearest(double lat, double lng) async => [
    for (final j in await _get<List<dynamic>>(
      '/api/stations/nearest',
      query: {'lat': lat, 'lng': lng},
    ))
      NetworkDtos.nearby(j as Json),
  ];

  /// Endpoint chưa có trong bảng API mục 9, cần thống nhất với backend.
  @override
  Future<List<BusStop>> fetchBusStops() async => [
    for (final j in await _get<List<dynamic>>('/api/bus-stops'))
      NetworkDtos.busStop(j as Json),
  ];

  @override
  Future<RoutePlan?> searchRoute(String fromId, String toId) async {
    try {
      return NetworkDtos.plan(
        await _get<Json>(
          '/api/routes/search',
          query: {'from': fromId, 'to': toId},
        ),
      );
    } on NotFoundFailure {
      return null;
    }
  }
}
