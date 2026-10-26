import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/domain/repositories/network_repository.dart';

/// UC5-03: tra cứu lộ trình giữa hai ga.
/// A1 trùng ga, A2 ga ngừng hoạt động: lỗi inline trước khi gọi API.
class SearchRoute {
  const SearchRoute(this._repo);
  final NetworkRepository _repo;

  Future<RoutePlan> call(String? fromId, String? toId) async {
    if (fromId == null || toId == null) {
      throw const ValidationFailure('Vui lòng chọn ga đi và ga đến');
    }
    if (fromId == toId) {
      throw const ValidationFailure('Ga đi và ga đến trùng nhau');
    }
    final catalog = await _repo.getCatalog();
    for (final id in [fromId, toId]) {
      final s = catalog.station(id);
      if (s == null) throw const NotFoundFailure('Không tìm thấy ga');
      if (!s.active) {
        throw ValidationFailure('Ga ${s.name} chưa hoạt động');
      }
    }
    return await _repo.searchRoute(fromId, toId);
  }
}
