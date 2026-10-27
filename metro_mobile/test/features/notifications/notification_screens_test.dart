import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/design_system/design_system.dart';

import '../../helpers/test_app.dart';

int _badge(WidgetTester t) => t
    .widget<MetroIconButton>(
      find.ancestor(
        of: find.byTooltip('Thông báo'),
        matching: find.byType(MetroIconButton),
      ),
    )
    .badgeCount;

void main() {
  testWidgets('badge chuông realtime, P60 đánh dấu đã đọc', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/home');
    expect(find.text('Hạng Bạc · 820 điểm'), findsOneWidget);
    expect(_badge(tester), 1);

    c.read(demoLedgerProvider).notify('OPERATION', 'Tuyến 1 tạm dừng');
    await settle(tester);
    expect(_badge(tester), 2);

    await tester.tap(find.byTooltip('Thông báo').first);
    await settle(tester);
    expect(currentPath(c), '/p/notifications');
    expect(find.text('Tuyến 1 tạm dừng'), findsOneWidget);
    await tester.tap(find.text('Đánh dấu đã đọc'));
    await settle(tester);
    expect(
      find.byWidgetPredicate((w) => w is NotificationTile && w.unread),
      findsNothing,
    );
    await unmount(tester, c);
  });

  testWidgets('Trang chủ: thẻ vận hành và tin tức có ảnh → P62', (
    tester,
  ) async {
    final c = await pumpPassengerAt(tester, '/p/home');
    final home = find.byType(Scrollable).first;
    final notice = find.text('Bảo trì thang cuốn ga Ba Son');
    await tester.scrollUntilVisible(notice, 200, scrollable: home);
    await tester.drag(home, const Offset(0, -200));
    await settle(tester);
    await tester.tap(notice.first);
    await settle(tester);
    expect(currentPath(c), '/p/news/N3');
    expect(find.textContaining('Hành khách vui lòng'), findsOneWidget);

    c.read(appRouterProvider).go('/p/home');
    await settle(tester);
    final news = find.text('Tăng chuyến giờ cao điểm từ 01/11');
    await tester.scrollUntilVisible(news, 200, scrollable: home);
    expect(find.byType(MetroImage), findsWidgets);
    await tester.drag(home, const Offset(0, -300));
    await settle(tester);
    await tester.tap(news);
    await settle(tester);
    expect(currentPath(c), '/p/news/N2');
    await unmount(tester, c);
  });

  testWidgets('P54: thông báo bắt buộc bị khóa (UC13-03 A1)', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/account/notification-settings');
    final locked = tester
        .widgetList<SwitchListTile>(find.byType(SwitchListTile))
        .where((s) => s.onChanged == null);
    expect(locked, hasLength(2));
    expect(locked.every((s) => s.value), isTrue);

    await tester.tap(find.text('Khuyến mãi'));
    await settle(tester);
    final promo = tester.widget<SwitchListTile>(
      find.widgetWithText(SwitchListTile, 'Khuyến mãi'),
    );
    expect(promo.value, isFalse);
    await unmount(tester, c);
  });

  testWidgets('P53 + P61 mở từ tab Tài khoản', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/account');
    await tester.tap(find.text('Thành viên & ưu đãi'));
    await settle(tester);
    expect(find.text('HẠNG BẠC'), findsOneWidget);
    expect(find.text('Còn 1.180 điểm lên Vàng'), findsOneWidget);
    c.read(appRouterProvider).go('/p/account/news');
    await settle(tester);
    expect(find.textContaining('VẬN HÀNH'), findsOneWidget);
    await unmount(tester, c);
  });
}
