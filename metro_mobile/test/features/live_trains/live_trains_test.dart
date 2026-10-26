import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/features/live_trains/data/repositories/live_trains_repository_impl.dart';
import 'package:metro_mobile/features/live_trains/data/sources/live_trains_fake_source.dart';
import 'package:metro_mobile/features/live_trains/domain/entities/train_position.dart';
import 'package:metro_mobile/features/live_trains/domain/usecases/estimate_arrivals.dart';
import 'package:metro_mobile/features/live_trains/domain/usecases/interpolate_trains.dart';
import 'package:metro_mobile/features/live_trains/live_trains_providers.dart';
import 'package:metro_mobile/features/live_trains/presentation/controllers/live_trains_controllers.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_data.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';

TrainPosition _t(
  String id,
  String next,
  String headsign,
  int eta, {
  double lat = 0,
  double lng = 0,
}) => TrainPosition(
  trainId: id,
  lineId: 'L1',
  lat: lat,
  lng: lng,
  nextStationId: next,
  etaSec: eta,
  headsignStationId: headsign,
);

void main() {
  final catalog = NetworkCatalog(
    lines: NetworkFakeData.lines,
    stations: NetworkFakeData.stations,
  );
  final l1 = catalog.line('L1')!.stationIds;

  test('nội suy vị trí giữa hai gói tin', () {
    final a = [_t('T1', 'BS', 'ST', 60, lat: 10, lng: 106)];
    final b = [_t('T1', 'BS', 'ST', 30, lat: 12, lng: 108)];
    final mid = interpolateTrains(a, b, .5).single;
    expect(mid.lat, closeTo(11, 1e-9));
    expect(mid.lng, closeTo(107, 1e-9));
    expect(interpolateTrains(a, b, 2).single.lat, 12);
    final fresh = interpolateTrains(const [], b, .5).single;
    expect(fresh.lat, 12);
  });

  test('ước tính tàu đến ga theo hai hướng', () {
    final arrivals = estimateArrivals(
      stationIds: l1,
      stationId: 'TD',
      trains: [
        _t('A', 'BTH', 'ST', 30), // còn 1 chặng nữa tới Thủ Đức
        _t('B', 'BS', 'ST', 0), // còn 8 chặng
        _t('C', 'CNC', 'BT', 90), // chiều về, còn 1 chặng
        _t('D', 'RC', 'BT', 10), // đã qua Thủ Đức theo chiều về
      ],
    );
    final toSuoiTien = arrivals.firstWhere((a) => a.headsignStationId == 'ST');
    expect(toSuoiTien.etaSecs, [150, 960]);
    final toBenThanh = arrivals.firstWhere((a) => a.headsignStationId == 'BT');
    expect(toBenThanh.etaSecs, [210]);
  });

  test('FakeStompSource phát gói tin đều đặn và repository gộp theo tàu', () {
    fakeAsync((async) {
      final source = LiveTrainsFakeSource(
        catalog: () async => catalog,
        clock: () => DateTime(2026, 10, 24, 8),
      );
      final updates = <List<TrainPosition>>[];
      final sub = LiveTrainsRepositoryImpl(source)
          .watchLine('L1')
          .listen(updates.add);
      async.flushMicrotasks();
      expect(updates.last, hasLength(6));
      final count = updates.length;
      async.elapse(const Duration(seconds: 3));
      expect(updates.length, greaterThan(count));
      for (final t in updates.last) {
        expect(l1, contains(t.nextStationId));
        expect(['BT', 'ST'], contains(t.headsignStationId));
      }
      unawaited(sub.cancel());
      async.flushMicrotasks();
      expect(source.activeSubscriptions, 0);
    });
  });

  test('tuyến quy hoạch không có tàu', () {
    fakeAsync((async) {
      final source = LiveTrainsFakeSource(catalog: () async => catalog);
      final updates = <Object?>[];
      final sub = source.subscribe('L2').listen(updates.add);
      async
        ..flushMicrotasks()
        ..elapse(const Duration(seconds: 10));
      expect(updates, isEmpty);
      unawaited(sub.cancel());
    });
  });

  test('không rò subscription khi provider bị hủy (rời màn)', () {
    fakeAsync((async) {
      final source = LiveTrainsFakeSource(catalog: () async => catalog);
      final container = ProviderContainer(
        overrides: [liveTrainsSourceProvider.overrideWithValue(source)],
      );
      final sub = container.listen(animatedTrainsProvider('L1'), (_, _) {});
      async.flushMicrotasks();
      expect(source.activeSubscriptions, 1);
      async.elapse(const Duration(seconds: 4));
      expect(container.read(animatedTrainsProvider('L1')), hasLength(6));

      sub.close();
      async
        ..flushMicrotasks()
        ..elapse(const Duration(seconds: 1));
      expect(source.activeSubscriptions, 0);
      container.dispose();
    });
  });
}
