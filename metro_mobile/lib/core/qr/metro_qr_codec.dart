import 'package:metro_mobile/core/qr/qr_codec.dart';
import 'package:metro_mobile/core/qr/qr_payload.dart';

/// Định dạng: `MTR1|<T|P>|<token>|<issuedAt epoch giây>`.
///
/// Thay cho `SeqrCodec` trong tài liệu vì gói `seqr` không có trên
/// pub.dev. Đổi thư viện/định dạng chỉ cần sửa file này.
class MetroQrCodec implements QrCodec {
  const MetroQrCodec();

  static const _prefix = 'MTR1';
  static const _sep = '|';
  static final _tokenPattern = RegExp(r'^[A-Za-z0-9_\-\.]{4,128}$');

  @override
  String encode(QrPayload payload) {
    final kind = payload.kind == QrKind.ticket ? 'T' : 'P';
    final epoch = payload.issuedAt.toUtc().millisecondsSinceEpoch ~/ 1000;
    return [_prefix, kind, payload.token, epoch].join(_sep);
  }

  @override
  QrPayload? decode(String raw) {
    final parts = raw.trim().split(_sep);
    if (parts.length != 4 || parts[0] != _prefix) return null;
    final kind = switch (parts[1]) {
      'T' => QrKind.ticket,
      'P' => QrKind.parking,
      _ => null,
    };
    final epoch = int.tryParse(parts[3]);
    if (kind == null || epoch == null) return null;
    if (!_tokenPattern.hasMatch(parts[2])) return null;
    return QrPayload(
      kind: kind,
      token: parts[2],
      issuedAt: DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true),
    );
  }
}
