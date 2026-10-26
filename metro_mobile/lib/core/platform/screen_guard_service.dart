import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';

/// Độ sáng 100% + chặn chụp màn hình (Android `FLAG_SECURE`) khi hiện QR.
/// Lỗi nền tảng (iOS, test) được bỏ qua: QR vẫn hiển thị bình thường.
class ScreenGuardService {
  const ScreenGuardService();

  static const _channel = MethodChannel('metro/screen_guard');

  Future<void> enable() async {
    await _try(
      () => ScreenBrightness.instance.setApplicationScreenBrightness(1),
    );
    await _try(() => _channel.invokeMethod<void>('setSecure', true));
  }

  /// Khôi phục độ sáng hệ thống khi rời màn QR.
  Future<void> disable() async {
    await _try(ScreenBrightness.instance.resetApplicationScreenBrightness);
    await _try(() => _channel.invokeMethod<void>('setSecure', false));
  }

  Future<void> _try(Future<void> Function() action) async {
    try {
      await action();
    } on Object {
      // Không có plugin / quyền: bỏ qua.
    }
  }
}
