import 'package:metro_mobile/features/wallet/domain/entities/parking_pass.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/features/wallet/domain/entities/wallet_transaction.dart';

typedef Json = Map<String, Object?>;

DateTime _date(Object? v) => DateTime.parse(v! as String);

/// JSON ↔ entity cho `/api/tickets`, `/api/transactions`, `/api/parking`.
abstract final class WalletDtos {
  static Ticket ticket(Json j) => Ticket(
    id: '${j['id']}',
    code: j['code'] as String? ?? '${j['id']}',
    typeCode: j['typeCode'] as String? ?? '',
    typeName: j['typeName'] as String? ?? 'Vé',
    status: j['status'] as String? ?? 'PAID',
    price: (j['price'] as num?)?.toInt() ?? 0,
    validFrom: _date(j['validFrom']),
    validUntil: _date(j['validUntil']),
    purchasedAt: _date(j['purchasedAt']),
    qrToken: j['qrToken'] as String? ?? '',
    fromName: j['fromName'] as String?,
    toName: j['toName'] as String?,
  );

  static WalletTransaction transaction(Json j) => WalletTransaction(
    id: '${j['id']}',
    orderCode: j['orderCode'] as String? ?? '',
    title: j['title'] as String? ?? '',
    amount: (j['amount'] as num?)?.toInt() ?? 0,
    method: j['method'] as String? ?? 'QR',
    status: j['status'] as String? ?? 'PENDING',
    createdAt: _date(j['createdAt']),
  );

  static ParkingPass parking(Json j) => ParkingPass(
    id: '${j['id']}',
    lotName: j['lotName'] as String? ?? '',
    plate: j['plate'] as String? ?? '',
    vehicleCode: j['vehicle'] as String? ?? 'MOTORBIKE',
    status: j['status'] as String? ?? 'CHUA_GUI',
    validUntil: _date(j['validUntil']),
    qrToken: j['qrToken'] as String? ?? '',
    since: j['since'] == null ? null : _date(j['since']),
  );
}
