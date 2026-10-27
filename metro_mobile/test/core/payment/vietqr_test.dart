import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/payment/vietqr.dart';

void main() {
  test('CRC-16/CCITT-FALSE chuẩn: "123456789" → 0x29B1', () {
    expect(VietQr.crc16('123456789'), 0x29B1);
  });

  test('VietQR có đủ trường NAPAS và CRC khớp nội dung', () {
    final qr = VietQr.build(
      bankBin: '970422',
      accountNumber: '0123456789',
      amount: 9120,
      content: 'DH80021',
    );
    expect(qr, startsWith('000201010212'));
    expect(
      qr,
      contains('38540010A00000072701240006970422011001234567890208QRIBFTTA'),
    );
    expect(qr, contains('5303704540491205802VN62110807DH80021'));
    final body = qr.substring(0, qr.length - 4);
    expect(body, endsWith('6304'));
    final crc = VietQr.crc16(body).toRadixString(16).toUpperCase();
    expect(qr.substring(qr.length - 4), crc.padLeft(4, '0'));
  });

  test('Nội dung bỏ dấu, viết hoa, tối đa 25 ký tự', () {
    final qr = VietQr.build(
      bankBin: '970422',
      accountNumber: '1',
      amount: 1,
      content: 'DH1-Vé lượt #1234567890123456789',
    );
    expect(qr, contains('0825DH1VE LUOT 12345678901234'));
  });
}
