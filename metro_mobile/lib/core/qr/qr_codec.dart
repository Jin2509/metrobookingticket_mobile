import 'package:metro_mobile/core/qr/qr_payload.dart';

/// Lớp trừu tượng duy nhất cho việc mã hóa/giải mã nội dung QR.
///
/// Feature chỉ phụ thuộc interface này, không import thư viện QR.
abstract interface class QrCodec {
  /// Chuyển payload thành chuỗi để vẽ QR.
  String encode(QrPayload payload);

  /// Đọc chuỗi thô từ camera. Trả `null` nếu không phải QR của Metro.
  QrPayload? decode(String raw);
}
