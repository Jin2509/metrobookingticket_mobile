import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/core/utils/geo.dart';
import 'package:metro_mobile/features/network/data/dtos/network_dtos.dart';
import 'package:metro_mobile/features/network/data/sources/network_source.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

/// Chỉ gọi các API **đọc** (GET) của Tuyến & Ga. App khách hàng không dùng
/// POST/PUT/DELETE (quyền `STATION_MANAGE`).
class NetworkRemoteSource implements NetworkSource {
  const NetworkRemoteSource(this._dio);
  final Dio _dio;

  static const _base = '/api/v1';

  /// Bán kính mặc định của "Ga gần tôi" (km).
  static const nearestRadiusKm = 5;

  Future<T> _get<T>(String path, {Map<String, dynamic>? query}) async {
    try {
      final res = await _dio.get<T>('$_base$path', queryParameters: query);
      return res.data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<List<Json>> _list(
    String path, {
    Map<String, dynamic>? query,
  }) async => [
    for (final j in await _get<List<dynamic>>(path, query: query)) j as Json,
  ];

  @override
  Future<NetworkCatalog> fetchCatalog() async {
    // eagerError: lỗi đầu tiên (đã là `Failure`) ném thẳng cho UI.
    final [lines, stations, transfers] = await Future.wait([
      _list('/lines/all'),
      _list('/stations/all'),
      _list('/line-transfers'),
    ], eagerError: true);
    final stops = await Future.wait([
      for (final l in lines) _list('/lines/${l['id']}/stations'),
    ], eagerError: true);

    final lineIdsOf = <String, List<String>>{};
    for (var i = 0; i < lines.length; i++) {
      for (final s in stops[i]) {
        final sid = '${(s['station'] as Json)['id']}';
        (lineIdsOf[sid] ??= []).add('${lines[i]['id']}');
      }
    }
    return NetworkCatalog(
      lines: [
        for (var i = 0; i < lines.length; i++)
          NetworkDtos.line(lines[i], stops[i]),
      ],
      // Ga chưa gắn tuyến nào thì khách hàng không đi được, bỏ qua.
      stations: [
        for (final s in stations)
          if (lineIdsOf['${s['id']}'] case final ids?)
            NetworkDtos.station(s, lineIds: ids),
      ],
      transfers: [for (final t in transfers) NetworkDtos.transfer(t)],
    );
  }

  /// Flow B.4: gọi song song chi tiết ga và các tuyến đi qua ga.
  @override
  Future<StationDetail> fetchStationDetail(String id) async {
    final [station, lines] = await Future.wait<Object>([
      _get<Json>('/stations/$id'),
      _list('/stations/$id/lines'),
    ], eagerError: true);
    return NetworkDtos.detail(station as Json, lines as List<Json>);
  }

  /// Response không có khoảng cách nên tự tính haversine.
  @override
  Future<List<NearbyStation>> fetchNearest(double lat, double lng) async => [
    for (final j in await _list(
      '/stations/nearest',
      query: {'lat': lat, 'lng': lng, 'radiusKm': nearestRadiusKm},
    ))
      _nearby(NetworkDtos.station(j), lat, lng),
  ];

  static NearbyStation _nearby(Station s, double lat, double lng) =>
      NearbyStation(
        station: s,
        distanceM: distanceMeters(lat, lng, s.lat, s.lng),
      );

  /// Backend chưa có API trạm buýt: lớp Buýt để trống.
  @override
  Future<List<BusStop>> fetchBusStops() async => const [];
}
