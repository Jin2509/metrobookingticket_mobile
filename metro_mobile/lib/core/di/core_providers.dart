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

/// Sự kiện phiên phát từ `AuthInterceptor`.
enum SessionEvent {
  /// Refresh token bị từ chối, token đã bị xóa.
  expired,

  /// Vừa có cặp token mới (vai trò có thể đã đổi).
  refreshed,
}

/// `AuthController` lắng nghe để cập nhật phiên (core không import features).
final sessionEventBusProvider = Provider<StreamController<SessionEvent>>((ref) {
  final bus = StreamController<SessionEvent>.broadcast();
  ref.onDispose(bus.close);
  return bus;
});

final dioProvider = Provider<Dio>((ref) {
  final bus = ref.watch(sessionEventBusProvider);
  return createDio(
    store: ref.watch(secureStoreProvider),
    onSessionExpired: () async => bus.add(SessionEvent.expired),
    onTokensRefreshed: () async => bus.add(SessionEvent.refreshed),
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
