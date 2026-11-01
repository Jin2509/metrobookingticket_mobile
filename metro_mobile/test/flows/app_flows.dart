import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/core/qr/qr_payload.dart';
import 'package:metro_mobile/design_system/design_system.dart';

import '../helpers/test_app.dart';

/// 4 luồng mục 7, dùng chung cho `flutter test` (máy dev/CI) và
/// `integration_test` (thiết bị thật).

/// 7.1 Email chưa xác thực: đăng nhập → OTP → đăng nhập lại.
Future<void> verifyEmailThenLoginFlow(WidgetTester tester) async {
  final c = await pumpApp(tester);
  await login(tester, 'pending@metro.vn', 'Metro@123');
  expect(currentPath(c), startsWith('/auth/otp?email=pending'));
  await tester.enterText(find.byType(TextField), '123456');
  await settle(tester);
  expect(currentPath(c), '/auth/login');
  await login(tester, 'pending@metro.vn', 'Metro@123');
  expect(currentPath(c), '/p/home');
  await unmount(tester, c);
}

Future<void> _tap(WidgetTester tester, String label) async {
  final f = find.widgetWithText(MetroButton, label);
  await tester.ensureVisible(f);
  await tester.tap(f);
  await settle(tester);
}

/// 7.2 Đặt vé lượt đủ 3 chạm từ Trang chủ.
Future<void> bookIn3TapsFlow(WidgetTester tester) async {
  final c = await pumpPassengerAt(tester, '/p/home');
  await _tap(tester, 'Thanh toán'); // chạm 1
  await _tap(tester, 'Thanh toán bằng QR · 9.120 ₫'); // chạm 2
  await tester.pump(const Duration(seconds: 3));
  await settle(tester);
  await _tap(tester, 'Mở QR vé'); // chạm 3
  expect(find.byType(QrPassView), findsOneWidget);
  await unmount(tester, c);
}

/// 7.3 Tra cứu lộ trình → kết quả → đặt vé.
Future<void> routeToBookingFlow(WidgetTester tester) async {
  final c = await pumpPassengerAt(tester, '/p/explore/route?from=BS&to=DHQG');
  expect(find.text('22 phút · 10 ga · Đi thẳng'), findsOneWidget);
  await _tap(tester, 'Đặt vé');
  expect(currentPath(c), '/p/book?type=SINGLE&from=BS&to=DHQG');
  expect(find.text('Xác nhận vé'), findsOneWidget);
  await unmount(tester, c);
}

/// 7.4 Nhân viên: check-in rồi check-out bằng camera.
Future<void> staffCheckInOutFlow(WidgetTester tester) async {
  final hub = ScannerHub();
  final c = await pumpStaffAt(tester, '/s/scan', scanners: hub);
  final token = c.read(demoLedgerProvider).findTicket('VE-MAU-01')!['qrToken']!;
  hub.last.show(QrKind.ticket, token as String);
  await settle(tester);
  expect(find.text('VÉ HỢP LỆ'), findsOneWidget);
  await tester.pump(const Duration(seconds: 3));
  await settle(tester);
  await tester.tap(find.text('RA GA'));
  await settle(tester);
  hub.last.show(QrKind.ticket, token);
  await settle(tester);
  expect(find.text('VÉ HỢP LỆ'), findsOneWidget);
  expect(c.read(demoLedgerProvider).findTicket('VE-MAU-01')!['status'], 'USED');
  c.read(appRouterProvider).go('/s/history');
  await settle(tester);
  expect(find.text('VE-MAU-01'), findsNWidgets(2));
  await unmount(tester, c);
}
