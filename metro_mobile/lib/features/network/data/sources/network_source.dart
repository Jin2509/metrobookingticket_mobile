import 'package:metro_mobile/features/network/domain/entities/metro_line.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/domain/entities/station.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

/// Lời gọi API thô của mạng lưới (remote hoặc fake).
abstract interface class NetworkSource {
  Future<List<MetroLine>> fetchLines();
  Future<List<Station>> fetchStations();
  Future<StationDetail> fetchStationDetail(String id);
  Future<List<NearbyStation>> fetchNearest(double lat, double lng);

  /// Trạm buýt quanh các ga (lớp Buýt trên bản đồ).
  Future<List<BusStop>> fetchBusStops();

  /// `null` khi không có lộ trình.
  Future<RoutePlan?> searchRoute(String fromId, String toId);
}
