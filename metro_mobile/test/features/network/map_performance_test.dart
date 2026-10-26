import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/design_system/organisms/metro_map/station_marker_layer.dart';
import 'package:metro_mobile/features/live_trains/data/sources/live_trains_fake_source.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_data.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';

import '../../helpers/test_app.dart';

/// Prompt 13: bản đồ có tàu realtime không được dựng lại marker ga mỗi
/// giây; chỉ lớp tàu cập nhật.
void main() {
  testWidgets('tàu chạy 1s/lần, marker ga không rebuild', (tester) async {
    var now = DateTime(2026, 10, 25, 8);
    final trains = LiveTrainsFakeSource(
      catalog: () async => NetworkCatalog(
        lines: NetworkFakeData.lines,
        stations: NetworkFakeData.stations,
      ),
      clock: () => now,
    );
    final c = await pumpPassengerAt(tester, '/p/explore/map', trains: trains);
    await tester.pump(const Duration(seconds: 1));
    final stations = tester.widget<StationMarkerLayer>(
      find.byType(StationMarkerLayer),
    );
    final before = tester.widget<LiveTrainLayer>(find.byType(LiveTrainLayer));
    expect(before.trains, hasLength(6));

    for (var i = 0; i < 6; i++) {
      now = now.add(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
    }

    final after = tester.widget<LiveTrainLayer>(find.byType(LiveTrainLayer));
    expect(identical(before, after), isFalse, reason: 'lớp tàu phải cập nhật');
    expect(
      before.trains.first.point == after.trains.first.point,
      isFalse,
      reason: 'tàu phải di chuyển',
    );
    expect(
      identical(
        stations,
        tester.widget<StationMarkerLayer>(find.byType(StationMarkerLayer)),
      ),
      isTrue,
      reason: 'marker ga không được dựng lại theo nhịp tàu',
    );
    expect(find.byType(Scaffold), findsWidgets);
    await unmount(tester, c);
  });
}
