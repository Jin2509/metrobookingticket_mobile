import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/design_system.dart';

import '../../helpers/test_app.dart';

Future<void> _ask(WidgetTester tester, String q) async {
  await tester.enterText(find.byType(TextField), q);
  await tester.tap(find.byTooltip('Gửi'));
  await settle(tester);
}

void main() {
  testWidgets('P70: hỏi giá vé → rich card có nút Đặt vé', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/assistant');
    expect(find.textContaining('Chào bạn!'), findsOneWidget);
    expect(find.byType(ChatQuickReplies), findsOneWidget);

    await _ask(tester, 'Giá vé Bến Thành đến Thủ Đức');
    expect(find.textContaining('12.000 ₫'), findsOneWidget);
    await tester.tap(find.widgetWithText(MetroButton, 'Đặt vé'));
    await settle(tester);
    expect(currentPath(c), '/p/book?type=SINGLE&from=BT&to=TD');
    await unmount(tester, c);
  });

  testWidgets('P70: gợi ý nhanh, like, A4 lỗi → Thử lại', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/assistant');
    await tester.tap(find.text('Giá vé BT – Suối Tiên?'));
    await settle(tester);
    expect(find.textContaining('15.000 ₫'), findsOneWidget);
    await _ask(tester, 'Điểm của tôi');
    expect(find.textContaining('820 điểm'), findsOneWidget);
    await tester.tap(find.byTooltip('Hữu ích').last);
    await settle(tester);

    await _ask(tester, '#loi');
    expect(find.text('Không gửi được câu hỏi'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Thử lại'), findsOneWidget);
    await unmount(tester, c);
  });
}
