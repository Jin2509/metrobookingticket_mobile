import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/network/data/repositories/network_repository_impl.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_source.dart';
import 'package:metro_mobile/features/network/domain/usecases/find_nearest_stations.dart';
import 'package:metro_mobile/features/network/domain/usecases/search_route.dart';

void main() {
  final repo = NetworkRepositoryImpl(NetworkFakeSource(latency: Duration.zero));

  test('SearchRoute: A1 trùng ga, A2 ga chưa hoạt động, A3 không có đường', () {
    final search = SearchRoute(repo);
    expect(
      () => search('BT', 'BT'),
      throwsA(
        isA<ValidationFailure>().having(
          (f) => f.message,
          'message',
          'Ga đi và ga đến trùng nhau',
        ),
      ),
    );
    expect(
      () => search('TDN', 'TD'),
      throwsA(
        isA<ValidationFailure>().having(
          (f) => f.message,
          'message',
          'Ga Tao Đàn chưa hoạt động',
        ),
      ),
    );
    expect(() => search(null, 'TD'), throwsA(isA<ValidationFailure>()));
  });

  test('SearchRoute trả lộ trình hợp lệ', () async {
    final plan = await SearchRoute(repo)('BS', 'ST');
    expect(plan.fromId, 'BS');
    expect(plan.toId, 'ST');
  });

  test('ga gần nhất: sắp theo khoảng cách, chỉ ga đang hoạt động', () async {
    // Gần Nhà hát Thành phố.
    final list = await FindNearestStations(repo)(10.7766, 106.7030, limit: 3);
    expect(list.first.station.name, 'Nhà hát Thành phố');
    expect(list.first.distanceM, lessThan(50));
    expect(list.every((n) => n.station.active), isTrue);
    expect(
      list.map((n) => n.distanceM).toList(),
      orderedEquals([...list.map((n) => n.distanceM)]..sort()),
    );
  });

  test('danh mục được cache trong phiên', () async {
    final a = await repo.getCatalog();
    final b = await repo.getCatalog();
    expect(identical(a, b), isTrue);
    expect(identical(a, await repo.getCatalog(refresh: true)), isFalse);
  });
}
