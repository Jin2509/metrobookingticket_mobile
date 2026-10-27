import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/app/settings/app_settings.dart';

import '../helpers/load_fonts.dart';
import '../helpers/test_app.dart';

/// Rà toàn app (Prompt 13): mọi màn chính ở khổ 360×800 phải dựng được
/// với cỡ chữ 1.3, tiếng Anh, dark mode, và đạt hướng dẫn trợ năng của
/// Flutter.
const passengerRoutes = [
  '/p/home',
  '/p/explore',
  '/p/explore/lines/L1',
  '/p/explore/stations/BT',
  '/p/explore/route?from=BT&to=TD',
  '/p/explore/map?nearby=1',
  '/p/explore/places?station=BT',
  '/p/tickets',
  '/p/tickets/VE-79990',
  '/p/tickets/parking/GX-1024',
  '/p/assistant',
  '/p/account',
  '/p/account/transactions',
  '/p/account/loyalty',
  '/p/account/news',
  '/p/account/notification-settings',
  '/p/notifications',
  '/p/news/N2',
  '/p/buy?from=BT&to=TD',
  '/p/book?type=SINGLE&from=BT&to=TD',
  '/p/fares',
  '/p/parking/book',
];

const staffRoutes = ['/s/scan', '/s/parking', '/s/history', '/s/account'];

const authRoutes = ['/auth/login', '/auth/register'];

Future<ProviderContainer> _open(WidgetTester tester, String path) async {
  final ProviderContainer c;
  if (path.startsWith('/s/')) {
    c = await pumpStaffAt(tester, path);
  } else if (path.startsWith('/p/')) {
    c = await pumpPassengerAt(tester, path);
  } else {
    c = await pumpApp(tester);
    c.read(appRouterProvider).go(path);
    await settle(tester);
  }
  tester.view.physicalSize = const Size(360, 800);
  await settle(tester);
  return c;
}

void main() {
  // Font thật để đo tràn layout sát thực tế (font test mặc định rộng hơn).
  setUpAll(loadAppFonts);
  final all = [...authRoutes, ...passengerRoutes, ...staffRoutes];

  group('cỡ chữ 1.3 không vỡ layout', () {
    for (final path in all) {
      testWidgets(path, (tester) async {
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final c = await _open(tester, path);
        expect(tester.takeException(), isNull);
        await unmount(tester, c);
      });
    }
  });

  group('tiếng Anh, cỡ chữ 1.3 không vỡ layout', () {
    for (final path in all) {
      testWidgets(path, (tester) async {
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final c = await _open(tester, path);
        await c
            .read(appSettingsProvider.notifier)
            .setLocale(const Locale('en'));
        await settle(tester);
        expect(tester.takeException(), isNull);
        final ctx = tester.element(find.byType(Scaffold).last);
        expect(Localizations.localeOf(ctx).languageCode, 'en');
        await unmount(tester, c);
      });
    }
  });

  group('dark mode Passenger', () {
    for (final path in [...authRoutes, ...passengerRoutes]) {
      testWidgets(path, (tester) async {
        tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
        final c = await _open(tester, path);
        expect(
          Theme.of(tester.element(find.byType(Scaffold).last)).brightness,
          Brightness.dark,
        );
        await unmount(tester, c);
      });
    }
  });

  group('trợ năng: vùng chạm, nhãn, tương phản', () {
    for (final path in all) {
      testWidgets(path, (tester) async {
        final handle = tester.ensureSemantics();
        final c = await _open(tester, path);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
        await unmount(tester, c);
      });
    }
  });
}
