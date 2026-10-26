import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/repositories/network_repository.dart';

/// UC4-02: danh sách tuyến và ga.
class GetCatalog {
  const GetCatalog(this._repo);
  final NetworkRepository _repo;

  Future<NetworkCatalog> call({bool refresh = false}) =>
      _repo.getCatalog(refresh: refresh);
}
