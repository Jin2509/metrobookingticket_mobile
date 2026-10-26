import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('đổi ngôn ngữ en và giao diện tối, lưu lại', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/account');
    expect(find.text('Cài đặt ứng dụng'.toUpperCase()), findsOneWidget);
    expect(find.text('Trang chủ'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('English'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('English'));
    await settle(tester);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Account'), findsWidgets);
    expect(find.text('Log out'), findsOneWidget);

    await tester.tap(find.text('Dark'));
    await settle(tester);
    expect(
      Theme.of(tester.element(find.text('Log out'))).brightness,
      Brightness.dark,
    );
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('locale'), 'en');
    expect(prefs.getString('theme_mode'), 'dark');
    await unmount(tester, c);
  });

  testWidgets('Staff: không có lựa chọn giao diện, chỉ ngôn ngữ', (
    tester,
  ) async {
    final c = await pumpStaffAt(tester, '/s/account');
    expect(find.text('Giao diện'), findsNothing);
    expect(find.text('Ngôn ngữ'), findsOneWidget);
    await unmount(tester, c);
  });
}
