import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/app/shells/passenger_shell.dart';
import 'package:metro_mobile/app/shells/staff_shell.dart';
import 'package:metro_mobile/app/shells/unsupported_role_screen.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('đăng xuất Passenger rồi đăng nhập Staff trên cùng máy', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    await login(tester, AuthDemo.passenger, AuthDemo.password);
    expect(currentPath(c), '/p/home');
    expect(find.byType(PassengerShell), findsOneWidget);

    await tester.tap(find.text('Tài khoản').last);
    await settle(tester);
    await tester.tap(find.text('Đăng xuất'));
    await settle(tester);
    await tester.tap(find.widgetWithText(TextButton, 'Đăng xuất'));
    await settle(tester);
    expect(currentPath(c), '/auth/login');

    await login(tester, AuthDemo.staff, AuthDemo.password);
    expect(currentPath(c), '/s/scan');
    expect(find.byType(StaffShell), findsOneWidget);
    expect(find.text('Soát vé'), findsWidgets);
  });

  testWidgets('deep link /p/tickets/:id mở đúng sau khi đăng nhập', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c.read(appRouterProvider).go('/p/tickets/VE-79990');
    await settle(tester);
    expect(currentPath(c), '/auth/login?from=%2Fp%2Ftickets%2FVE-79990');

    await login(tester, AuthDemo.passenger, AuthDemo.password);
    expect(currentPath(c), '/p/tickets/VE-79990');
    expect(find.text('Mã: VE-79990'), findsOneWidget);
  });

  testWidgets('còn refresh token: Splash vào thẳng shell đúng vai trò', (
    tester,
  ) async {
    final c = await pumpApp(
      tester,
      storage: {'refresh_token': 'fake-refresh-${AuthDemo.staff}'},
    );
    expect(currentPath(c), '/s/scan');
  });

  testWidgets('Admin thấy màn dùng web quản trị', (tester) async {
    final c = await pumpApp(tester);
    await login(tester, AuthDemo.admin, AuthDemo.password);
    expect(currentPath(c), '/unsupported');
    expect(find.byType(UnsupportedRoleScreen), findsOneWidget);
    expect(find.text('Vui lòng dùng trang quản trị web'), findsOneWidget);
  });

  testWidgets('Passenger không vào được route Staff', (tester) async {
    final c = await pumpApp(tester);
    await login(tester, AuthDemo.passenger, AuthDemo.password);
    c.read(appRouterProvider).go('/s/scan');
    await settle(tester);
    expect(currentPath(c), '/p/home');
    expect(find.byType(Scaffold), findsWidgets);
  });
}
