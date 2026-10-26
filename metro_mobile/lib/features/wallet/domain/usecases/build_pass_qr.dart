import 'package:metro_mobile/core/qr/qr_codec.dart';
import 'package:metro_mobile/core/qr/qr_payload.dart';
import 'package:metro_mobile/features/wallet/domain/entities/parking_pass.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';

/// Tạo chuỗi QR qua `QrCodec`: chỉ chứa loại + token + thời điểm phát
/// hành, không có tên/SĐT/email (P5).
class BuildPassQr {
  const BuildPassQr(this._codec);
  final QrCodec _codec;

  String ticket(Ticket t) => _codec.encode(
    QrPayload(kind: QrKind.ticket, token: t.qrToken, issuedAt: t.purchasedAt),
  );

  String parking(ParkingPass p) => _codec.encode(
    QrPayload(
      kind: QrKind.parking,
      token: p.qrToken,
      issuedAt: p.since ?? p.validUntil,
    ),
  );
}
