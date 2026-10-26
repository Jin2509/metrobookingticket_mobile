import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

/// Lỗi ném dưới dạng `Failure`.
abstract interface class NetworkRepository {
  /// Tuyến + ga. Gọi lại trả bản cache trừ khi [refresh].
  Future<NetworkCatalog> getCatalog({bool refresh = false});

  Future<StationDetail> getStationDetail(String stationId);

  Future<List<NearbyStation>> findNearest(double lat, double lng);

  Future<List<BusStop>> getBusStops();

  /// `NotFoundFailure` nếu không có lộ trình (A3).
  Future<RoutePlan> searchRoute(String fromId, String toId);
}
