import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/domain/repositories/network_repository.dart';

/// UC5-02: ga gần nhất, sắp theo khoảng cách, tối đa `limit` ga.
class FindNearestStations {
  const FindNearestStations(this._repo);
  final NetworkRepository _repo;

  Future<List<NearbyStation>> call(
    double lat,
    double lng, {
    int limit = 5,
  }) async {
    final list = await _repo.findNearest(lat, lng);
    final sorted = [...list]
      ..sort((a, b) => a.distanceM.compareTo(b.distanceM));
    return sorted.take(limit).toList();
  }
}
