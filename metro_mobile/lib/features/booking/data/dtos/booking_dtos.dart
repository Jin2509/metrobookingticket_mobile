import 'package:metro_mobile/core/payment/vietqr.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';

typedef Json = Map<String, Object?>;

int _int(Object? v) => (v as num?)?.toInt() ?? 0;

/// JSON ↔ entity cho `/api/v1/public/ticket-products`, `/public/fares`,
/// `POST /api/v1/tickets` và `/api/v1/me/payment-orders`.
abstract final class BookingDtos {
  /// Mua online chỉ có chuyển khoản VietQR qua SePay.
  /// [method]: `SEPAY_QR`, hoặc `CARD` cho thanh toán giả ở dev.
  static Json purchase(BookingRequest r, {String method = 'SEPAY_QR'}) => {
    'productCode': r.typeCode,
    'periods': 1,
    'paymentMethod': method,
    'originStationId': ?_long(r.fromId),
    'destinationStationId': ?_long(r.toId),
  };

  static int? _long(String? id) => id == null ? null : int.tryParse(id);

  /// `products` từ `/public/ticket-products`, `fares` từ `/public/fares`.
  static FareTable fareTable(List<Json> products, List<Json> fares) {
    final single = fares
        .where((f) => f['productCode'] == 'SINGLE')
        .followedBy(fares)
        .firstOrNull;
    return FareTable(
      types: [
        for (final p in products)
          TicketType(
            code: p['code']! as String,
            name: p['name']! as String,
            validity: _validity(p),
            price: p['singleJourney'] == true ? null : _int(p['priceVnd']),
          ),
      ],
      singleFare: single == null
          ? null
          : SingleFare(
              perKm: _int(single['farePerKmVnd']),
              minFare: _int(single['minFareVnd']),
            ),
    );
  }

  static String _validity(Json p) {
    if (p['singleJourney'] == true) return 'Một lượt trong ngày';
    final n = _int(p['durationValue']);
    return switch (p['durationUnit']) {
      'DAY' => '${n * 24} giờ',
      'WEEK' => '${n * 7} ngày',
      'MONTH' => '$n tháng',
      _ => '',
    };
  }

  /// Backend chưa có API xem trước đơn: giá gốc lấy từ báo giá (vé lượt)
  /// hoặc giá loại vé. Ưu đãi sinh viên / CPoint được trừ khi tạo đơn.
  static OrderPreview preview({
    required BookingRequest request,
    required TicketType type,
    required int basePrice,
    String? fromName,
    String? toName,
  }) => OrderPreview(
    request: request,
    typeName: type.name,
    fromName: fromName,
    toName: toName,
    basePrice: basePrice,
    discounts: const [],
  );

  /// `PaymentInstruction`: tự dựng chuỗi VietQR từ ngân hàng + số TK.
  /// Không biết mã BIN của ngân hàng thì [PaymentSession.qrContent] rỗng.
  static PaymentSession session(Json j) {
    final orderCode = j['orderCode']! as String;
    final amount = _int(j['amountVnd']);
    final bankCode = j['bank'] as String? ?? '';
    final bin = VietQr.binOf(bankCode);
    final account = '${j['accountNumber'] ?? ''}';
    final content = j['transferContent'] as String? ?? orderCode;
    return PaymentSession(
      orderId: orderCode,
      orderCode: orderCode,
      amount: amount,
      qrContent: bin == null
          ? ''
          : VietQr.build(
              bankBin: bin,
              accountNumber: account,
              amount: amount,
              content: content,
            ),
      expiresAt: DateTime.parse(j['expiresAt']! as String),
      transfer: BankTransfer(
        bankBin: bin ?? '',
        bankName: bankCode,
        accountNumber: account,
        accountName: j['accountHolder'] as String? ?? '',
        content: content,
      ),
    );
  }

  static PaymentUpdate update(Json j, {String? ticketId, String? parkingId}) {
    final status = switch (j['status']) {
      'PAID' => PaymentStatus.success,
      'EXPIRED' => PaymentStatus.expired,
      'CANCELLED' => PaymentStatus.cancelled,
      _ => PaymentStatus.pending,
    };
    final paid = status == PaymentStatus.success;
    return PaymentUpdate(
      orderId: j['orderCode']! as String,
      status: status,
      ticketId: paid ? ticketId : null,
      parkingId: paid ? parkingId : null,
    );
  }
}
