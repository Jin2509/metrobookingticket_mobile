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

  /// Flow B.4: gọi song song chi tiết ga, các tuyến đi qua ga, trạm buýt và
  /// tiện ích quanh ga. Buýt/tiện ích lấy từ dịch vụ ngoài nên lỗi thì để
  /// trống, không làm hỏng cả màn chi tiết ga.
  @override
  Future<StationDetail> fetchStationDetail(String id) async {
    final [station, lines, bus, facilities] = await Future.wait<Object>([
      _get<Json>('/stations/$id'),
      _list('/stations/$id/lines'),
      _optionalList('/stations/$id/bus'),
      _optionalList('/stations/$id/facilities'),
    ], eagerError: true);
    return NetworkDtos.detail(
      station as Json,
      lines as List<Json>,
      bus: bus as List<Json>,
      facilities: facilities as List<Json>,
    );
  }

  Future<List<Json>> _optionalList(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      return await _list(path, query: query);
    } on Object {
      return const [];
    }
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

  /// Bán kính tìm trạm buýt cho lớp Buýt trên bản đồ (km).
  static const mapBusRadiusKm = 0.5;

  /// Lớp Buýt: trạm buýt quanh từng ga (backend cache theo ga), bỏ trùng.
  @override
  Future<List<BusStop>> fetchBusStops() async {
    final stations = await _list('/stations/all');
    final perStation = await Future.wait([
      for (final s in stations)
        _optionalList(
          '/stations/${s['id']}/bus',
          query: {'radiusKm': mapBusRadiusKm, 'limit': 5},
        ),
    ]);
    final seen = <String>{};
    return [
      for (final rows in perStation)
        for (final b in NetworkDtos.busStops(rows))
          if (seen.add(b.id)) b,
    ];
  }
}
