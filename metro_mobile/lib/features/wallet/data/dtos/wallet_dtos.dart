import 'package:metro_mobile/features/wallet/domain/entities/parking_pass.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/features/wallet/domain/entities/wallet_transaction.dart';

typedef Json = Map<String, Object?>;

DateTime _date(Object? v) => DateTime.parse(v! as String);
DateTime? _dateOrNull(Object? v) => v == null ? null : _date(v);
int _int(Object? v) => (v as num?)?.toInt() ?? 0;

/// JSON ↔ entity cho `/api/v1/me/tickets`, `/me/transactions`,
/// `/me/parking-bookings`. Trạng thái backend được đổi sang mã app đang dùng.
abstract final class WalletDtos {
  /// `TicketStatus` backend → mã của app.
  static String ticketStatus(String? s) => switch (s) {
    'ACTIVE' => 'PAID',
    'PENDING_PAYMENT' => 'PENDING',
    null => 'PAID',
    _ => s,
  };

  /// Mã của app → `TicketStatus` backend (lọc `?status=`).
  static String ticketStatusParam(String s) => switch (s) {
    'PAID' => 'ACTIVE',
    'PENDING' => 'PENDING_PAYMENT',
    _ => s,
  };

  static Ticket ticket(Json j) {
    final purchased = _date(j['purchasedAt']);
    final from = j['originStation'] as Json?;
    final to = j['destinationStation'] as Json?;
    return Ticket(
      id: '${j['id']}',
      code: j['ticketCode'] as String? ?? '${j['id']}',
      typeCode: j['productCode'] as String? ?? '',
      typeName: j['productName'] as String? ?? 'Vé',
      status: ticketStatus(j['status'] as String?),
      price: _int(j['priceVnd']),
      validFrom: _dateOrNull(j['validFrom']) ?? purchased,
      validUntil: _dateOrNull(j['validUntil']) ?? purchased,
      purchasedAt: purchased,
      qrToken: j['qrToken'] as String? ?? '',
      fromName: from?['name'] as String?,
      toName: to?['name'] as String?,
    );
  }

  static const _purposeTitle = {
    'TICKET': 'Mua vé tàu',
    'TICKET_FARE_ADJUSTMENT': 'Thu bù vé lượt',
    'PARKING_SESSION': 'Phí gửi xe',
    'PARKING_MONTHLY_PASS': 'Vé tháng gửi xe',
    'PARKING_BOOKING': 'Đặt chỗ gửi xe',
  };

  /// `PaymentView`.
  static WalletTransaction transaction(Json j) => WalletTransaction(
    id: '${j['id']}',
    orderCode: j['providerRef'] as String? ?? '${j['referenceId'] ?? ''}',
    title: _purposeTitle[j['purpose']] ?? 'Thanh toán',
    amount: _int(j['amountVnd']),
    method: j['method'] == 'SEPAY_QR' ? 'QR' : '${j['method'] ?? 'QR'}',
    status: switch (j['status']) {
      'SUCCEEDED' => 'SUCCESS',
      'REFUND_PENDING' => 'PENDING',
      final s => '${s ?? 'PENDING'}',
    },
    createdAt: _date(j['createdAt']),
  );

  /// `BookingResponse` của đặt chỗ gửi xe.
  static ParkingPass parking(Json j, {DateTime? now}) {
    final end = _date(j['endAt']);
    final expired = end.isBefore(now ?? DateTime.now());
    return ParkingPass(
      id: '${j['id']}',
      lotName: j['lotName'] as String? ?? '',
      plate: j['plateNumber'] as String? ?? '',
      vehicleCode: j['vehicleType'] as String? ?? 'MOTORBIKE',
      status: switch (j['status']) {
        'PENDING_PAYMENT' => 'PENDING',
        'PAID' => expired ? 'HET_HAN' : 'CHUA_GUI',
        'CHECKED_IN' => 'DANG_GUI',
        'COMPLETED' => 'LAY_XE',
        _ => 'HET_HAN',
      },
      validUntil: end,
      qrToken: j['qrToken'] as String? ?? '',
      since: _dateOrNull(j['checkinAt']),
    );
  }
}
