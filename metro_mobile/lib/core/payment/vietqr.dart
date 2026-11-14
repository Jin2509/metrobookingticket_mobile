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

  /// Mã BIN NAPAS theo tên ngân hàng SePay trả về (`MBBank`, `VCB`...).
  /// Nhận luôn chuỗi 6 số nếu backend đã trả BIN.
  static String? binOf(String bank) {
    final key = bank.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');
    if (RegExp(r'^\d{6}$').hasMatch(key)) return key;
    return _bins[key];
  }

  static const _bins = {
    'MB': '970422',
    'MBBANK': '970422',
    'VCB': '970436',
    'VIETCOMBANK': '970436',
    'ACB': '970416',
    'TPB': '970423',
    'TPBANK': '970423',
    'BIDV': '970418',
    'ICB': '970415',
    'VIETINBANK': '970415',
    'TCB': '970407',
    'TECHCOMBANK': '970407',
    'VPB': '970432',
    'VPBANK': '970432',
    'OCB': '970448',
    'MSB': '970426',
    'STB': '970403',
    'SACOMBANK': '970403',
    'HDB': '970437',
    'HDBANK': '970437',
    'VIB': '970441',
    'SHB': '970443',
    'EIB': '970431',
    'EXIMBANK': '970431',
    'SEAB': '970440',
    'SEABANK': '970440',
    'KLB': '970452',
    'KIENLONGBANK': '970452',
    'NCB': '970419',
    'LPB': '970449',
    'LPBANK': '970449',
    'VBA': '970405',
    'AGRIBANK': '970405',
  };

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
