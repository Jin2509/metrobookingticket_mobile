import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/features/network/domain/repositories/network_repository.dart';

/// UC4-02 / UC6: chi tiết ga, tiện ích và xe buýt quanh ga.
class GetStationDetail {
  const GetStationDetail(this._repo);
  final NetworkRepository _repo;

  Future<StationDetail> call(String stationId) =>
      _repo.getStationDetail(stationId);
}
