import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/core/permissions/location_consent.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_painter.dart';
import 'package:metro_mobile/features/live_trains/data/sources/live_trains_fake_source.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_data.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/line_card.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('P20: mở sơ đồ 3D, chạm ga, xem chi tiết → P22', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/explore');
    expect(find.byType(Network3dView), findsOneWidget);
    await tester.tap(find.text('Sơ đồ 3D'));
    await settle(tester);
    expect(currentPath(c), '/p/explore/network');

    final view = find.byType(Network3dView);
    final painter =
        tester
                .widget<CustomPaint>(
                  find.byWidgetPredicate(
                    (w) => w is CustomPaint && w.painter is Network3dPainter,
                  ),
                )
                .painter!
            as Network3dPainter;
    final size = tester.getSize(view);
    final node = painter.scene.lines
        .expand((l) => l.nodes)
        .firstWhere((n) => n.station.id == 'TD');
    await tester.tapAt(
      tester.getTopLeft(view) +
          painter.camera.project(node.position, size).offset,
    );
    await tester.pump();
    expect(find.text('Thủ Đức'), findsWidgets);

    await tester.tap(find.text('Chi tiết'));
    await settle(tester);
    expect(currentPath(c), '/p/explore/stations/TD');
    await unmount(tester, c);
  });

  testWidgets('sơ đồ: chuyển sang 2D, Bến Thành chỉ một nút', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/explore/network');
    await tester.tap(find.text('2D'));
    await settle(tester);
    expect(
      find.descendant(
        of: find.byType(NetworkDiagram),
        matching: find.text('Bến Thành'),
      ),
      findsOneWidget,
    );
    await unmount(tester, c);
  });

  testWidgets('P20 → P21: danh sách tuyến, ga đúng thứ tự', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/explore');
    final line = find.text('Bến Thành – Suối Tiên');
    await tester.scrollUntilVisible(
      line,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await settle(tester);
    expect(find.byType(LineCard), findsNWidgets(2));
    expect(find.text('Quy hoạch'), findsOneWidget);

    await tester.tap(find.text('Bến Thành – Suối Tiên'));
    await settle(tester);
    expect(currentPath(c), '/p/explore/lines/L1');
    final y = [
      for (final n in ['Bến Thành', 'Nhà hát Thành phố', 'Ba Son'])
        tester.getTopLeft(find.text(n).first).dy,
    ];
    expect(y, orderedEquals([...y]..sort()));
    expect(find.text('Trực tiếp'), findsOneWidget);
    expect(find.text('Tàu đang tới'), findsWidgets);
    await unmount(tester, c);
  });

  testWidgets('P22: tàu sắp đến, Quanh ga gộp tiện ích + xe buýt', (
    tester,
  ) async {
    final c = await pumpPassengerAt(tester, '/p/explore/stations/BT');
    expect(find.text('Ga Bến Thành'), findsOneWidget);
    expect(find.text('Tàu sắp đến'), findsOneWidget);
    expect(find.text('Bến xe Suối Tiên'), findsOneWidget);

    await tester.tap(find.text('Quanh ga'));
    await settle(tester);
    expect(find.text('Chợ Bến Thành'), findsWidgets);
    expect(find.text('Bệnh viện Sài Gòn'), findsOneWidget);
    expect(find.text('Trạm Hàm Nghi'), findsOneWidget);
    expect(find.text('93'), findsOneWidget);

    // Lọc Y tế: chỉ còn bệnh viện.
    await tester.tap(find.widgetWithText(ChoiceChip, 'Y tế'));
    await settle(tester);
    expect(find.text('Bệnh viện Sài Gòn'), findsOneWidget);
    expect(find.text('Trạm Hàm Nghi'), findsNothing);
    await unmount(tester, c);
  });

  testWidgets('bản đồ gộp Quanh ga: mở sẵn ngăn và lọc theo nhóm', (
    tester,
  ) async {
    final c = await pumpPassengerAt(
      tester,
      '/p/explore/map?panel=places&station=TD',
    );
    expect(find.byType(MetroMapView), findsOneWidget);
    expect(find.text('Bệnh viện TP. Thủ Đức'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Xe buýt'));
    await settle(tester);
    expect(find.text('Trạm Võ Văn Ngân'), findsOneWidget);
    expect(find.text('Bệnh viện TP. Thủ Đức'), findsNothing);
    await unmount(tester, c);
  });

  testWidgets('P25/P26: deep link tra lộ trình, lỗi trùng ga', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/explore/route?from=BT&to=TD');
    expect(find.text('22 phút · 10 ga · Đi thẳng'), findsOneWidget);
    expect(find.text('12.000 ₫'), findsOneWidget);
    expect(find.byType(LineDiagram), findsOneWidget);

    await tester.tap(find.byTooltip('Đổi chiều'));
    await tester.tap(find.widgetWithText(MetroButton, 'Tìm lộ trình'));
    await settle(tester);
    expect(find.text('22 phút · 10 ga · Đi thẳng'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('P25: ga chưa hoạt động báo lỗi inline (A2)', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/explore/route?from=TDN&to=TD');
    expect(find.text('Ga Tao Đàn chưa hoạt động'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('P23/P24: ga gần bạn theo vị trí', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/explore/map?nearby=1');
    expect(find.byType(MetroMapView), findsOneWidget);
    expect(find.text('Ga gần bạn'), findsOneWidget);
    expect(find.byType(StationTile), findsWidgets);
    final first = tester.widget<StationTile>(find.byType(StationTile).first);
    expect(first.station.name, 'Bến Thành');
    await unmount(tester, c);
  });

  testWidgets('P24 A1: từ chối vị trí → chọn trên bản đồ', (tester) async {
    final c = await pumpPassengerAt(
      tester,
      '/p/explore/map?nearby=1',
      location: const LocationDenied(),
    );
    expect(find.text('Bật vị trí'), findsOneWidget);
    await tester.tap(find.text('Chọn trên bản đồ'));
    await settle(tester);
    expect(find.text('Chạm vào bản đồ để chọn vị trí của bạn'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('rời màn chi tiết ga thì hủy subscribe tàu', (tester) async {
    late LiveTrainsFakeSource source;
    source = LiveTrainsFakeSource(
      catalog: () async => NetworkCatalog(
        lines: NetworkFakeData.lines,
        stations: NetworkFakeData.stations,
      ),
      clock: () => DateTime(2026, 10, 24, 8),
    );
    final c = await pumpPassengerAt(
      tester,
      '/p/explore/stations/TD',
      trains: source,
    );
    expect(source.activeSubscriptions, 1);
    // Về Khám phá (cùng tab): màn chi tiết ga bị hủy, Trang chủ đang ẩn
    // (TickerMode tắt) nên cũng không nghe.
    c.read(appRouterProvider).go('/p/explore');
    await settle(tester);
    expect(source.activeSubscriptions, 0);
    expect(find.byType(Scaffold), findsWidgets);
    await unmount(tester, c);
  });

  testWidgets('bản đồ: đổi qua lại Ga gần bạn và Quanh ga trên cùng màn', (
    tester,
  ) async {
    final c = await pumpPassengerAt(tester, '/p/explore/map?nearby=1');
    expect(find.byType(StationTile), findsWidgets);
    await tester.tap(find.text('Quanh ga'));
    await settle(tester);
    expect(find.byType(StationTile), findsNothing);
    expect(currentPath(c), '/p/explore/map?nearby=1');
    await unmount(tester, c);
  });
}
