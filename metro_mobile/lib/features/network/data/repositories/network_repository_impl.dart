import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/network/data/sources/network_source.dart';
import 'package:metro_mobile/features/network/data/sources/route_planner.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/domain/repositories/network_repository.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  NetworkRepositoryImpl(this._source, {this.planner = const RoutePlanner()});

  final NetworkSource _source;
  final RoutePlanner planner;
  Future<NetworkCatalog>? _catalog;

  @override
  Future<NetworkCatalog> getCatalog({bool refresh = false}) async {
    if (refresh) _catalog = null;
    final pending = _catalog ??= _source.fetchCatalog();
    try {
      return await pending;
    } on Object {
      // Lỗi thì bỏ cache để lần sau tải lại.
      if (identical(_catalog, pending)) _catalog = null;
      rethrow;
    }
  }

  @override
  Future<StationDetail> getStationDetail(String stationId) =>
      _source.fetchStationDetail(stationId);

  /// API ga gần nhất không trả tuyến đi qua ga: lấy từ danh mục, đồng thời
  /// bỏ ga chưa thuộc tuyến nào.
  @override
  Future<List<NearbyStation>> findNearest(double lat, double lng) async {
    // Danh mục thường đã cache sẵn từ màn trước.
    final catalog = await getCatalog();
    final list = await _source.fetchNearest(lat, lng);
    return [
      for (final n in list)
        if (catalog.station(n.station.id) case final s?)
          NearbyStation(
            station: n.station.copyWith(lineIds: s.lineIds),
            distanceM: n.distanceM,
          ),
    ];
  }

  @override
  Future<List<BusStop>> getBusStops() => _source.fetchBusStops();

  /// Backend chưa có API tìm lộ trình: tính từ danh mục tuyến/ga.
  @override
  Future<RoutePlan> searchRoute(String fromId, String toId) async {
    final plan = planner.plan(await getCatalog(), fromId, toId);
    if (plan == null) {
      throw const NotFoundFailure('Không tìm thấy lộ trình phù hợp');
    }
    return plan;
  }
}
