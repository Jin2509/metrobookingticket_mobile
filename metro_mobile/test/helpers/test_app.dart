import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:metro_mobile/app/app.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/core/permissions/camera_permission.dart';
import 'package:metro_mobile/core/permissions/location_consent.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_fake_source.dart';
import 'package:metro_mobile/features/booking/booking_providers.dart';
import 'package:metro_mobile/features/booking/data/sources/booking_fake_source.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/chatbot/chatbot_providers.dart';
import 'package:metro_mobile/features/chatbot/data/sources/chat_fake_source.dart';
import 'package:metro_mobile/features/live_trains/data/sources/live_trains_fake_source.dart';
import 'package:metro_mobile/features/live_trains/live_trains_providers.dart';
import 'package:metro_mobile/features/loyalty/data/sources/loyalty_fake_source.dart';
import 'package:metro_mobile/features/loyalty/loyalty_providers.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_source.dart';
import 'package:metro_mobile/features/network/network_providers.dart';
import 'package:metro_mobile/features/notifications/data/sources/notification_fake_source.dart';
import 'package:metro_mobile/features/notifications/notification_providers.dart';
import 'package:metro_mobile/features/parking/data/sources/parking_fake_source.dart';
import 'package:metro_mobile/features/parking/parking_providers.dart';
import 'package:metro_mobile/features/staff/parking_control/data/sources/parking_control_fake_source.dart';
import 'package:metro_mobile/features/staff/staff_providers.dart';
import 'package:metro_mobile/features/staff/ticket_control/data/sources/ticket_control_fake_source.dart';
import 'package:metro_mobile/features/wallet/data/sources/wallet_fake_source.dart';
import 'package:metro_mobile/features/wallet/wallet_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_scanner.dart';

export 'fake_scanner.dart';

/// Chạy toàn app với Fake source (không trễ) và secure storage giả.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  Map<String, String> storage = const {},
  LocationResult location = const LocationGranted(10.7730, 106.6990),
  LiveTrainsFakeSource? trains,
  PaymentStatus paymentOutcome = PaymentStatus.success,
  DateTime Function()? ledgerClock,
  ScannerHub? scanners,
  CameraAccess camera = CameraAccess.granted,
}) async {
  await initializeDateFormatting('vi_VN');
  FlutterSecureStorage.setMockInitialValues(Map.of(storage));
  SharedPreferences.setMockInitialValues({});
  tester.view
    ..physicalSize = const Size(412, 915)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    overrides: [
      authSourceProvider.overrideWith(
        (ref) => AuthFakeSource(
          ref.watch(secureStoreProvider),
          latency: Duration.zero,
        ),
      ),
      networkSourceProvider.overrideWithValue(
        NetworkFakeSource(latency: Duration.zero),
      ),
      liveTrainsSourceProvider.overrideWith(
        (ref) =>
            trains ??
            LiveTrainsFakeSource(
              catalog: ref.watch(networkRepositoryProvider).getCatalog,
              clock: () => DateTime(2026, 10, 24, 8),
              interval: null,
            ),
      ),
      if (ledgerClock != null)
        demoLedgerProvider.overrideWithValue(DemoLedger(clock: ledgerClock)),
      bookingSourceProvider.overrideWith(
        (ref) => BookingFakeSource(
          ledger: ref.watch(demoLedgerProvider),
          network: ref.watch(networkRepositoryProvider),
          latency: Duration.zero,
          outcome: paymentOutcome,
        ),
      ),
      walletRepositoryProvider.overrideWith(
        (ref) => WalletFakeSource(
          ref.watch(demoLedgerProvider),
          latency: Duration.zero,
        ),
      ),
      parkingRepositoryProvider.overrideWith(
        (ref) => ParkingFakeSource(
          ref.watch(demoLedgerProvider),
          latency: Duration.zero,
        ),
      ),
      loyaltyRepositoryProvider.overrideWith(
        (ref) => LoyaltyFakeSource(
          ref.watch(demoLedgerProvider),
          latency: Duration.zero,
        ),
      ),
      notificationRepositoryProvider.overrideWith(
        (ref) => NotificationFakeSource(
          ref.watch(demoLedgerProvider),
          latency: Duration.zero,
        ),
      ),
      chatRepositoryProvider.overrideWith(
        (ref) => ChatFakeSource(
          network: ref.watch(networkRepositoryProvider),
          wallet: ref.watch(walletRepositoryProvider),
          loyalty: ref.watch(loyaltyRepositoryProvider),
          latency: Duration.zero,
        ),
      ),
      ticketControlRepositoryProvider.overrideWith(
        (ref) => TicketControlFakeSource(
          ref.watch(demoLedgerProvider),
          latency: Duration.zero,
        ),
      ),
      parkingControlRepositoryProvider.overrideWith(
        (ref) => ParkingControlFakeSource(
          ref.watch(demoLedgerProvider),
          latency: Duration.zero,
        ),
      ),
      cameraPermissionProvider.overrideWithValue(FakeCameraPermission(camera)),
      qrScannerFactoryProvider.overrideWithValue(
        (scanners ?? ScannerHub()).create,
      ),
      locationServiceProvider.overrideWithValue(FakeLocation(location)),
      mapTilesEnabledProvider.overrideWithValue(false),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const MetroApp()),
  );
  await settle(tester);
  return container;
}

/// Chờ Future + chuyển trang xong (Splash có vòng quay nên không dùng
/// `pumpAndSettle` vô hạn).
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

String currentPath(ProviderContainer c) =>
    c.read(appRouterProvider).state.uri.toString();

Future<void> login(WidgetTester tester, String email, String password) async {
  await tester.enterText(find.byType(TextField).at(0), email);
  await tester.enterText(find.byType(TextField).at(1), password);
  await tester.tap(find.widgetWithText(MetroButton, 'Đăng nhập'));
  await settle(tester);
}

/// Gỡ cây widget rồi dispose container để hủy timer của tàu realtime
/// trước khi flutter_test kiểm tra timer còn treo.
Future<void> unmount(WidgetTester tester, ProviderContainer c) async {
  await tester.pumpWidget(const SizedBox());
  c.dispose();
  await tester.pump(const Duration(seconds: 1));
}

/// Vị trí giả: trả kết quả cố định, không gọi GPS.
class FakeLocation implements LocationService {
  FakeLocation(this.result);
  final LocationResult result;
  int settingsOpened = 0;

  @override
  Future<LocationResult> current() async => result;

  @override
  Future<void> openSettings() async => settingsOpened++;
}

/// Đăng nhập Passenger rồi mở [path].
Future<ProviderContainer> pumpPassengerAt(
  WidgetTester tester,
  String path, {
  LocationResult location = const LocationGranted(10.7730, 106.6990),
  LiveTrainsFakeSource? trains,
  PaymentStatus paymentOutcome = PaymentStatus.success,
  DateTime Function()? ledgerClock,
  ScannerHub? scanners,
}) async {
  final c = await pumpApp(
    tester,
    location: location,
    trains: trains,
    paymentOutcome: paymentOutcome,
    ledgerClock: ledgerClock,
    scanners: scanners,
  );
  await login(tester, 'passenger@metro.vn', 'Metro@123');
  c.read(appRouterProvider).go(path);
  await settle(tester);
  return c;
}

/// Đăng nhập Staff (ga Thủ Đức) rồi mở [path].
Future<ProviderContainer> pumpStaffAt(
  WidgetTester tester,
  String path, {
  ScannerHub? scanners,
  CameraAccess camera = CameraAccess.granted,
  DateTime Function()? ledgerClock,
}) async {
  final c = await pumpApp(
    tester,
    scanners: scanners,
    camera: camera,
    ledgerClock: ledgerClock,
  );
  await login(tester, 'staff@metro.vn', 'Metro@123');
  c.read(appRouterProvider).go(path);
  await settle(tester);
  return c;
}
