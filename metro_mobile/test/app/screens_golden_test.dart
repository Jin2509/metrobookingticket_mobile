@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/core/permissions/camera_permission.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/l10n/l10n.dart';

import '../helpers/load_fonts.dart';
import '../helpers/test_app.dart';

/// Golden các màn của giai đoạn 3 ở khung 360×800.
void main() {
  setUpAll(loadAppFonts);

  Future<void> shoot(WidgetTester tester, String name) async {
    tester.view.physicalSize = const Size(360, 800);
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  testWidgets('A1 login', (tester) async {
    await pumpApp(tester);
    await shoot(tester, 'a1_login');
  });

  testWidgets('A2 register', (tester) async {
    final c = await pumpApp(tester);
    c.read(appRouterProvider).go('/auth/register');
    await shoot(tester, 'a2_register');
  });

  testWidgets('A3 otp', (tester) async {
    await pumpApp(tester);
    await login(tester, AuthDemo.twoFactor, AuthDemo.password);
    await tester.enterText(find.byType(TextField), '48');
    await shoot(tester, 'a3_otp');
  });

  testWidgets('P50 passenger account', (tester) async {
    final c = await pumpApp(tester);
    await login(tester, AuthDemo.passenger, AuthDemo.password);
    c.read(appRouterProvider).go('/p/account');
    await shoot(tester, 'p50_passenger_account');
  });

  testWidgets('S40 staff account', (tester) async {
    final c = await pumpApp(tester);
    await login(tester, AuthDemo.staff, AuthDemo.password);
    c.read(appRouterProvider).go('/s/account');
    await shoot(tester, 's40_staff_account');
  });

  for (final (name, path) in [
    ('p20_explore', '/p/explore'),
    ('p21_line_detail', '/p/explore/lines/L1'),
    ('p22_station_detail', '/p/explore/stations/BT'),
    ('p26_route_result', '/p/explore/route?from=BS&to=DHQG'),
    ('p23_map_nearby', '/p/explore/map?nearby=1'),
  ]) {
    testWidgets(name, (tester) async {
      final c = await pumpPassengerAt(tester, path);
      await shoot(tester, name);
      await unmount(tester, c);
    });
  }

  // Giai đoạn 5: đồng hồ cố định để ngày trên vé không đổi theo ngày chạy.
  DateTime fixed() => DateTime.utc(2026, 10, 24, 1);
  for (final (name, path) in [
    ('p10_home', '/p/home'),
    ('p30_booking_confirm', '/p/book?type=SINGLE&from=BT&to=TD'),
    ('p33_success', '/p/book/result?order=DH1&status=success&ticket=VE-79990'),
    ('p33_failed', '/p/book/result?order=DH1&status=failed'),
    ('p33_refund', '/p/book/result?order=DH1&status=refundPending&refund=TS-1'),
    ('p34_fares', '/p/fares'),
    ('p40_my_tickets', '/p/tickets'),
    ('p41_ticket_qr', '/p/tickets/VE-79990'),
    ('p41_ticket_expired', '/p/tickets/VE-79957'),
    ('p52_transactions', '/p/account/transactions'),
    ('p35_parking_book', '/p/parking/book'),
    ('p53_loyalty', '/p/account/loyalty'),
    ('p54_notification_settings', '/p/account/notification-settings'),
    ('p60_notifications', '/p/notifications'),
    ('p61_news', '/p/account/news'),
  ]) {
    testWidgets(name, (tester) async {
      final c = await pumpPassengerAt(tester, path, ledgerClock: fixed);
      await shoot(tester, name);
      await unmount(tester, c);
    });
  }

  testWidgets('p32_payment_qr', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        theme: MetroTheme.light,
        home: Scaffold(
          appBar: AppBar(title: const Text('Thanh toán')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              PaymentQrSheet(
                qrData: 'METROPAY|DH80021|9120',
                amount: 9120,
                orderCode: 'DH80021',
                timeLeft: const Duration(minutes: 9, seconds: 42),
                expired: false,
                onExpired: () {},
                onRenew: () {},
                onCancel: () {},
              ),
            ],
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/p32_payment_qr.png'),
    );
  });

  testWidgets('p70_chat', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/assistant', ledgerClock: fixed);
    await tester.enterText(find.byType(TextField), 'Giá vé Ba Son đến Thủ Đức');
    await tester.tap(find.byTooltip('Gửi'));
    await settle(tester);
    await shoot(tester, 'p70_chat');
    await unmount(tester, c);
  });

  // Giai đoạn 7: Staff (theme tối).
  for (final (name, path, camera) in [
    ('s10_ticket_scan', '/s/scan', CameraAccess.granted),
    ('s10_camera_denied', '/s/scan', CameraAccess.permanentlyDenied),
    ('s20_parking_control', '/s/parking', CameraAccess.granted),
  ]) {
    testWidgets(name, (tester) async {
      final c = await pumpStaffAt(
        tester,
        path,
        camera: camera,
        ledgerClock: fixed,
      );
      await shoot(tester, name);
      await unmount(tester, c);
    });
  }

  for (final valid in [true, false]) {
    testWidgets('s11_result_${valid ? 'valid' : 'invalid'}', (tester) async {
      tester.view
        ..physicalSize = const Size(360, 800)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          debugShowCheckedModeBanner: false,
          theme: MetroTheme.staff,
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: ScanResultSheet(
                valid: valid,
                autoClose: null,
                onClose: () {},
                title: valid ? 'VÉ HỢP LỆ' : 'KHÔNG HỢP LỆ',
                lines: valid
                    ? const [
                        'Vé lượt · Bến Thành – Thủ Đức',
                        'Hiệu lực đến 25/10/2026 23:59',
                        'Ghi nhận: 10:41 · Vào ga',
                      ]
                    : const [
                        'Lý do: Check-out sai ga',
                        'Vé: Bến Thành – An Phú',
                        'Ga hiện tại: Thủ Đức',
                      ],
              ),
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/s11_result_${valid ? 'valid' : 'invalid'}.png',
        ),
      );
    });
  }

  // Prompt 13: dark mode Passenger.
  for (final (name, path) in [
    ('p10_home_dark', '/p/home'),
    ('p40_my_tickets_dark', '/p/tickets'),
  ]) {
    testWidgets(name, (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      final c = await pumpPassengerAt(tester, path, ledgerClock: fixed);
      await shoot(tester, name);
      await unmount(tester, c);
    });
  }
}
