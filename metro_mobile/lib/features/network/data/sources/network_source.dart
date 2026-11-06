import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

/// Lời gọi API thô của mạng lưới (remote hoặc fake). Chỉ đọc: app khách hàng
/// không gọi API thêm/sửa/xoá tuyến, ga, chuyển tuyến.
abstract interface class NetworkSource {
  /// Tuyến (kèm thứ tự ga, số liệu đoạn) + ga + điểm chuyển tuyến.
  Future<NetworkCatalog> fetchCatalog();

  Future<StationDetail> fetchStationDetail(String id);

  /// Ga trong bán kính quanh vị trí, chưa sắp xếp.
  Future<List<NearbyStation>> fetchNearest(double lat, double lng);

  /// Trạm buýt quanh các ga (lớp Buýt trên bản đồ).
  Future<List<BusStop>> fetchBusStops();
}
