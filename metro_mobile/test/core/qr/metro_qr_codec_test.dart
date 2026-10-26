import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/qr/metro_qr_codec.dart';
import 'package:metro_mobile/core/qr/qr_payload.dart';

void main() {
  const codec = MetroQrCodec();
  final issuedAt = DateTime.utc(2026, 10, 24, 3, 41, 7);

  group('MetroQrCodec', () {
    test('encode rồi decode trả lại đúng payload', () {
      for (final kind in QrKind.values) {
        final payload = QrPayload(
          kind: kind,
          token: 'tk_80021-abc',
          issuedAt: issuedAt,
        );
        expect(codec.decode(codec.encode(payload)), payload);
      }
    });

    test('chuỗi QR chỉ chứa prefix, loại, token và thời điểm (không PII)', () {
      final raw = codec.encode(
        QrPayload(kind: QrKind.ticket, token: 'tk_1234', issuedAt: issuedAt),
      );
      expect(raw, 'MTR1|T|tk_1234|${issuedAt.millisecondsSinceEpoch ~/ 1000}');
    });

    test('từ chối QR không phải của Metro', () {
      const invalid = [
        '',
        'https://momo.vn/pay',
        'MTR1|X|tk_1234|1700000000',
        'MTR1|T|tk_1234|abc',
        'MTR2|T|tk_1234|1700000000',
        'MTR1|T|a b|1700000000',
        'MTR1|T|tk_1234',
      ];
      for (final raw in invalid) {
        expect(codec.decode(raw), isNull, reason: raw);
      }
    });
  });
}
