import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_data.dart';
import 'package:metro_mobile/features/network/data/sources/route_planner.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/presentation/mappers/diagram_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

final vi = lookupAppLocalizations(const Locale('vi'));

void main() {
  final catalog = NetworkCatalog(
    lines: NetworkFakeData.lines,
    stations: NetworkFakeData.stations,
  );

  test('thứ tự ga khớp station_order', () {
    final l1 = catalog.line('L1')!;
    final names = catalog.stationsOf(l1).map((s) => s.name).toList();
    expect(names.first, 'Bến Thành');
    expect(names[1], 'Nhà hát Thành phố');
    expect(names.last, 'Bến xe Suối Tiên');
    expect(names, hasLength(14));
    final stops = lineDiagramStops(vi, catalog, l1);
    expect(stops.map((s) => s.id), l1.stationIds);
    expect(stops.first.interchange, isTrue);
    expect(stops.first.subtitle, 'Chuyển Tuyến 2');
  });

  test('đi thẳng trên Tuyến 1: Bến Thành → Thủ Đức', () {
    final plan = const RoutePlanner().plan(catalog, 'BT', 'TD')!;
    expect(plan.legs, hasLength(1));
    expect(plan.stationCount, 10);
    expect(plan.transfers, 0);
    expect(plan.minutes, 22);
    expect(plan.fare, 12000);
  });

  test('tuyến quy hoạch không được dùng để tìm đường', () {
    expect(const RoutePlanner().plan(catalog, 'TL', 'TD'), isNull);
  });

  test('khi cả hai tuyến khai thác: có ga chuyển tuyến Bến Thành', () {
    const planner = RoutePlanner(includePlanned: true);
    final plan = planner.plan(catalog, 'TDN', 'TD')!;
    expect(plan.legs.map((l) => l.lineId), ['L2', 'L1']);
    expect(plan.legs.first.stationIds, ['TDN', 'BT']);
    expect(plan.transfers, 1);
    expect(plan.stationCount, 11);

    final stops = routeDiagramStops(vi, catalog, plan);
    final transfer = stops.firstWhere((s) => s.id == 'BT');
    expect(transfer.interchange, isTrue);
    expect(transfer.subtitle, 'Đổi sang Tuyến 1 (~3 phút)');
    expect(stops.last.name, 'Thủ Đức');
    expect(stops.any((s) => s.collapsedCount == 9), isTrue);
  });
}
