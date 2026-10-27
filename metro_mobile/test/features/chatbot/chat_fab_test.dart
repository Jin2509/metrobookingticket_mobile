import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/chatbot/presentation/widgets/chat_panel.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('4 tab, Trợ lý là nút nổi chỉ ở màn gốc của tab', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/home');
    final nav = tester.widget<MetroBottomNav>(find.byType(MetroBottomNav));
    expect(nav.items.map((i) => i.label), [
      'Trang chủ',
      'Khám phá',
      'Vé',
      'Tài khoản',
    ]);
    expect(find.byTooltip('Trợ lý Metro'), findsOneWidget);

    c.read(appRouterProvider).go('/p/explore/stations/BT');
    await settle(tester);
    expect(find.byTooltip('Trợ lý Metro'), findsNothing);
    await unmount(tester, c);
  });

  testWidgets('nút nổi mở sheet chat; nút trong câu trả lời đóng sheet '
      'rồi mở màn đích', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/explore');
    await tester.tap(find.byTooltip('Trợ lý Metro'));
    await settle(tester);
    expect(find.byType(ChatPanel), findsOneWidget);
    expect(find.textContaining('Chào bạn!'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField),
      'Giá vé Bến Thành đến Thủ Đức',
    );
    await tester.tap(find.byTooltip('Gửi'));
    await settle(tester);
    await tester.tap(find.widgetWithText(MetroButton, 'Đặt vé'));
    await settle(tester);
    expect(find.byType(ChatPanel), findsNothing);
    expect(currentPath(c), '/p/book?type=SINGLE&from=BT&to=TD');

    // Hội thoại còn nguyên khi mở lại.
    c.read(appRouterProvider).go('/p/home');
    await settle(tester);
    await tester.tap(find.byTooltip('Trợ lý Metro'));
    await settle(tester);
    expect(
      find.descendant(
        of: find.byType(ChatPanel),
        matching: find.textContaining('12.000 ₫'),
      ),
      findsOneWidget,
    );
    await unmount(tester, c);
  });
}
