import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/network/dio_client.dart';
import 'package:metro_mobile/core/network/stomp_client.dart';
import 'package:metro_mobile/core/permissions/camera_permission.dart';
import 'package:metro_mobile/core/permissions/location_consent.dart';
import 'package:metro_mobile/core/qr/camera_scanner.dart';
import 'package:metro_mobile/core/qr/metro_qr_codec.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';

final secureStoreProvider = Provider<SecureStore>((_) => SecureStore());

/// Phát tín hiệu khi refresh token thất bại. `AuthController` lắng nghe
/// để đăng xuất (core không import features).
final sessionExpiredBusProvider = Provider<StreamController<void>>((ref) {
  final bus = StreamController<void>.broadcast();
  ref.onDispose(bus.close);
  return bus;
});

final dioProvider = Provider<Dio>((ref) {
  final bus = ref.watch(sessionExpiredBusProvider);
  return createDio(
    store: ref.watch(secureStoreProvider),
    onSessionExpired: () async => bus.add(null),
  );
});

/// Một kết nối STOMP dùng chung cho cả app.
final stompClientProvider = Provider<MetroStompClient>((ref) {
  final store = ref.watch(secureStoreProvider);
  return MetroStompClient(url: Env.wsUrl, token: () => store.accessToken);
});

final locationServiceProvider = Provider<LocationService>(
  (_) => const GeolocatorLocationService(),
);

/// Dữ liệu giao dịch demo dùng chung cho các Fake source.
final demoLedgerProvider = Provider<DemoLedger>((_) => DemoLedger());

final cameraPermissionProvider = Provider<CameraPermission>(
  (_) => const SystemCameraPermission(),
);

/// Tạo máy quét mới cho mỗi màn quét (màn tự dispose khi rời đi).
final qrScannerFactoryProvider = Provider<QrScanner Function()>(
  (_) =>
      () => CameraScanner(codec: const MetroQrCodec()),
);
