import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:metro_mobile/core/permissions/camera_permission.dart';
import 'package:metro_mobile/core/qr/camera_scanner.dart';
import 'package:metro_mobile/core/qr/qr_payload.dart';

/// Máy quét giả: test đẩy mã như camera vừa đọc được.
class FakeQrScanner implements QrScanner {
  final _reads = StreamController<ScanRead>.broadcast();
  int torch = 0;
  bool disposed = false;

  void show(QrKind kind, String token) => _reads.add(
    ScanDecoded(QrPayload(kind: kind, token: token, issuedAt: DateTime(2026))),
  );

  void garbage() => _reads.add(const ScanUnreadable('https://momo.vn'));

  @override
  Stream<ScanRead> get reads => _reads.stream;

  @override
  Widget preview({BoxFit fit = BoxFit.cover}) =>
      const ColoredBox(color: Color(0xFF263238));

  @override
  Future<void> toggleTorch() async => torch++;

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {
    disposed = true;
    await _reads.close();
  }
}

/// Ghi lại các máy quét được tạo để test lấy cái đang mở.
class ScannerHub {
  final created = <FakeQrScanner>[];

  FakeQrScanner get last => created.last;

  QrScanner create() {
    final s = FakeQrScanner();
    created.add(s);
    return s;
  }
}

class FakeCameraPermission implements CameraPermission {
  FakeCameraPermission(this.access);
  CameraAccess access;
  int settingsOpened = 0;

  @override
  Future<CameraAccess> request() async => access;

  @override
  Future<void> openSettings() async => settingsOpened++;
}
