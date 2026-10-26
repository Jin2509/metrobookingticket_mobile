import 'package:flutter/widgets.dart';
import 'package:metro_mobile/core/qr/qr_codec.dart';
import 'package:metro_mobile/core/qr/qr_payload.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Kết quả một lần đọc từ camera.
sealed class ScanRead {
  const ScanRead();
}

class ScanDecoded extends ScanRead {
  const ScanDecoded(this.payload);
  final QrPayload payload;
}

/// Đọc được mã nhưng không phải QR Metro (toast "Quét lại").
class ScanUnreadable extends ScanRead {
  const ScanUnreadable(this.raw);
  final String raw;
}

/// Máy quét QR mà feature dùng. Test thay bằng bản giả đẩy `ScanRead`.
abstract interface class QrScanner {
  Stream<ScanRead> get reads;
  Widget preview({BoxFit fit});
  Future<void> toggleTorch();
  Future<void> start();
  Future<void> stop();
  Future<void> dispose();
}

/// Bọc `mobile_scanner`: camera sau → chuỗi thô → `QrCodec.decode`.
class CameraScanner implements QrScanner {
  CameraScanner({required QrCodec codec})
    : _codec = codec,
      _controller = MobileScannerController(
        formats: const [BarcodeFormat.qrCode],
        detectionSpeed: DetectionSpeed.noDuplicates,
      );

  final QrCodec _codec;
  final MobileScannerController _controller;

  @override
  Stream<ScanRead> get reads => _controller.barcodes
      .expand((capture) => capture.barcodes)
      .map((b) => b.rawValue)
      .where((raw) => raw != null && raw.isNotEmpty)
      .map((raw) => _toRead(raw!));

  ScanRead _toRead(String raw) {
    final payload = _codec.decode(raw);
    return payload == null ? ScanUnreadable(raw) : ScanDecoded(payload);
  }

  /// Widget preview camera, dùng trong `ScanView` của design system.
  @override
  Widget preview({BoxFit fit = BoxFit.cover}) =>
      MobileScanner(controller: _controller, fit: fit);

  @override
  Future<void> toggleTorch() => _controller.toggleTorch();

  @override
  Future<void> start() => _controller.start();

  @override
  Future<void> stop() => _controller.stop();

  @override
  Future<void> dispose() => _controller.dispose();
}
