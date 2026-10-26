import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/network/data/sources/network_source.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/domain/repositories/network_repository.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  NetworkRepositoryImpl(this._source);

  final NetworkSource _source;
  Future<NetworkCatalog>? _catalog;

  @override
  Future<NetworkCatalog> getCatalog({bool refresh = false}) async {
    if (refresh) _catalog = null;
    final pending = _catalog ??= _load();
    try {
      return await pending;
    } on Object {
      // Lỗi thì bỏ cache để lần sau tải lại.
      if (identical(_catalog, pending)) _catalog = null;
      rethrow;
    }
  }

  Future<NetworkCatalog> _load() async {
    final (lines, stations) = await (
      _source.fetchLines(),
      _source.fetchStations(),
    ).wait;
    return NetworkCatalog(lines: lines, stations: stations);
  }

  @override
  Future<StationDetail> getStationDetail(String stationId) =>
      _source.fetchStationDetail(stationId);

  @override
  Future<List<NearbyStation>> findNearest(double lat, double lng) =>
      _source.fetchNearest(lat, lng);

  @override
  Future<List<BusStop>> getBusStops() => _source.fetchBusStops();

  @override
  Future<RoutePlan> searchRoute(String fromId, String toId) async {
    final plan = await _source.searchRoute(fromId, toId);
    if (plan == null) {
      throw const NotFoundFailure('Không tìm thấy lộ trình phù hợp');
    }
    return plan;
  }
}
