import 'package:metro_mobile/core/utils/vn_text.dart';

/// Chuỗi VietQR (EMVCo, NAPAS 247) cho chuyển khoản có số tiền và nội
/// dung cố định. Đây là định dạng SePay dùng (qr.sepay.vn); mọi ứng dụng
/// ngân hàng/ví hỗ trợ VietQR đều quét được.
///
/// Cấu trúc: 00 phiên bản · 01 "12" (QR động) · 38 thông tin người nhận
/// (GUID NAPAS + BIN + số TK + dịch vụ QRIBFTTA) · 53 tiền tệ 704 ·
/// 54 số tiền · 58 VN · 62/08 nội dung · 63 CRC16-CCITT.
abstract final class VietQr {
  static const _napasGuid = 'A000000727';
  static const _toAccount = 'QRIBFTTA';

  static String build({
    required String bankBin,
    required String accountNumber,
    required int amount,
    required String content,
  }) {
    final beneficiary = _f('00', bankBin) + _f('01', accountNumber);
    final merchant =
        _f('00', _napasGuid) + _f('01', beneficiary) + _f('02', _toAccount);
    final body = [
      _f('00', '01'),
      _f('01', '12'),
      _f('38', merchant),
      _f('53', '704'),
      _f('54', '$amount'),
      _f('58', 'VN'),
      _f('62', _f('08', _ascii(content))),
      '6304',
    ].join();
    return body + crc16(body).toRadixString(16).toUpperCase().padLeft(4, '0');
  }

  static String _f(String id, String value) =>
      '$id${value.length.toString().padLeft(2, '0')}$value';

  /// Ngân hàng chỉ nhận nội dung ASCII, tối đa 25 ký tự: bỏ dấu, viết
  /// HOA, bỏ ký tự đặc biệt.
  static String _ascii(String s) {
    final clean = normalizeVn(s)
        .toUpperCase()
        .replaceAll(RegExp('[^A-Z0-9 ]'), '');
    return clean.length > 25 ? clean.substring(0, 25) : clean;
  }

  /// CRC-16/CCITT-FALSE (poly 0x1021, init 0xFFFF).
  static int crc16(String data) {
    var crc = 0xFFFF;
    for (final c in data.codeUnits) {
      crc ^= c << 8;
      for (var i = 0; i < 8; i++) {
        crc = (crc & 0x8000) != 0 ? (crc << 1) ^ 0x1021 : crc << 1;
        crc &= 0xFFFF;
      }
    }
    return crc;
  }
}
