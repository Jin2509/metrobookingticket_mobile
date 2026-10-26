import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';

typedef Json = Map<String, Object?>;

int _int(Object? v) => (v as num?)?.toInt() ?? 0;

/// JSON ↔ entity cho `/api/orders`, `/api/payments`, `/api/ticket-types`.
abstract final class BookingDtos {
  static Json request(BookingRequest r) => {
    'ticketType': r.typeCode,
    'fromStationId': ?r.fromId,
    'toStationId': ?r.toId,
  };

  static FareTable fareTable(Json j) => FareTable(
    types: [
      for (final t in j['types']! as List)
        TicketType(
          code: (t as Json)['code']! as String,
          name: t['name']! as String,
          validity: t['validity'] as String? ?? '',
          price: (t['price'] as num?)?.toInt(),
        ),
    ],
    singleTiers: [
      for (final t in j['singleTiers']! as List)
        FareTier(
          maxStations: ((t as Json)['maxStations'] as num?)?.toInt(),
          price: _int(t['price']),
        ),
    ],
  );

  static OrderPreview preview(Json j, BookingRequest r) => OrderPreview(
    request: r,
    typeName: j['typeName'] as String? ?? '',
    fromName: j['fromName'] as String?,
    toName: j['toName'] as String?,
    basePrice: _int(j['basePrice']),
    discounts: [
      for (final d in j['discounts'] as List? ?? const [])
        Discount(
          label: (d as Json)['label']! as String,
          amount: _int(d['amount']),
        ),
    ],
    pointsAvailable: _int(j['pointsAvailable']),
    pointsToUse: _int(j['pointsToUse']),
    pointsValue: _int(j['pointsValue']),
  );

  static PaymentSession session(Json j) => PaymentSession(
    orderId: '${j['orderId']}',
    orderCode: j['orderCode'] as String? ?? '${j['orderId']}',
    amount: _int(j['amount']),
    qrContent: j['qrContent'] as String? ?? '',
    expiresAt: DateTime.parse(j['expiresAt']! as String),
  );

  static PaymentUpdate update(Json j) => PaymentUpdate(
    orderId: '${j['orderId']}',
    status: PaymentStatus.parse(j['status'] as String?),
    ticketId: j['ticketId'] as String?,
    parkingId: j['parkingId'] as String?,
    refundCode: j['refundCode'] as String?,
  );
}
