import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/booking/data/dtos/booking_dtos.dart';
import 'package:metro_mobile/features/booking/data/sources/booking_fake_catalog.dart';
import 'package:metro_mobile/features/booking/data/sources/booking_source.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';
import 'package:metro_mobile/features/network/domain/repositories/network_repository.dart';

/// Giả lập đặt vé: giá theo lộ trình, ưu đãi demo, thanh toán tự có kết
/// quả [outcome] ở lần poll thứ [settlePolls] (~3s, kịch bản 12.1).
/// Vé và giao dịch được ghi vào `DemoLedger`.
class BookingFakeSource implements BookingSource {
  BookingFakeSource({
    required DemoLedger ledger,
    required NetworkRepository network,
    this.latency = const Duration(milliseconds: 300),
    this.outcome = PaymentStatus.success,
    this.settlePolls = 1,
    this.qrTtl = const Duration(minutes: 10),
  }) : _ledger = ledger,
       _network = network;

  final DemoLedger _ledger;
  final NetworkRepository _network;
  final Duration latency;
  final PaymentStatus outcome;
  final int settlePolls;
  final Duration qrTtl;
  final _polls = <String, int>{};

  Future<void> _wait() => Future<void>.delayed(latency);

  Record _order(String id) =>
      _ledger.orders[id] ?? (throw const NotFoundFailure('Không tìm thấy đơn'));

  @override
  Future<FareTable> fetchFareTable() async {
    await _wait();
    return BookingFakeCatalog.fareTable;
  }

  @override
  Future<OrderPreview> preview(BookingRequest r) async {
    await _wait();
    final type = BookingFakeCatalog.type(r.typeCode);
    String? fromName;
    String? toName;
    var base = type.price ?? 0;
    final discounts = <Discount>[];
    if (type.needsStations) {
      final catalog = await _network.getCatalog();
      for (final id in [r.fromId!, r.toId!]) {
        final s = catalog.station(id);
        if (s == null || !s.active) {
          throw ValidationFailure('Ga ${s?.name ?? id} chưa hoạt động');
        }
      }
      fromName = catalog.station(r.fromId!)!.name;
      toName = catalog.station(r.toId!)!.name;
      base = (await _network.searchRoute(r.fromId!, r.toId!)).fare;
      discounts.add(
        Discount(
          label: BookingFakeCatalog.promoLabel,
          amount: base * BookingFakeCatalog.promoPercent ~/ 100,
        ),
      );
    }
    final afterPromo = base - discounts.fold(0, (s, d) => s + d.amount);
    discounts.add(
      Discount(
        label: BookingFakeCatalog.tierLabel,
        amount: afterPromo * BookingFakeCatalog.tierPercent ~/ 100,
      ),
    );
    return OrderPreview(
      request: r,
      typeName: type.name,
      fromName: fromName,
      toName: toName,
      basePrice: base,
      discounts: discounts,
      pointsAvailable: BookingFakeCatalog.points,
      pointsToUse: BookingFakeCatalog.pointsToUse,
      pointsValue: BookingFakeCatalog.pointsValue,
    );
  }

  @override
  Future<PaymentSession> createPayment(
    BookingRequest r, {
    required bool usePoints,
  }) async {
    final p = await preview(r);
    final code = _ledger.nextCode();
    final amount = p.total(usePoints: usePoints);
    _ledger.orders['DH$code'] = {
      'orderId': 'DH$code',
      'orderCode': 'DH$code',
      'amount': amount,
      'status': 'PENDING',
      'typeCode': r.typeCode,
      'typeName': p.typeName,
      'fromId': r.fromId,
      'fromName': p.fromName,
      'toId': r.toId,
      'toName': p.toName,
      'qrContent': 'METROPAY|DH$code|$amount',
      'expiresAt': _ledger.clock().toUtc().add(qrTtl).toIso8601String(),
    };
    return BookingDtos.session(_ledger.orders['DH$code']!);
  }

  @override
  Future<PaymentSession> fetchSession(String orderId) async {
    await _wait();
    return BookingDtos.session(_order(orderId));
  }

  @override
  Future<PaymentUpdate> fetchStatus(String orderId) async {
    final o = _order(orderId);
    final polls = _polls[orderId] = (_polls[orderId] ?? 0) + 1;
    if (o['status'] == 'PENDING' && polls > settlePolls) _settle(o);
    return BookingDtos.update(o);
  }

  @override
  Future<PaymentSession> renew(String orderId) async {
    await _wait();
    final o = _order(orderId)
      ..['status'] = 'PENDING'
      ..['expiresAt'] = _ledger.clock().toUtc().add(qrTtl).toIso8601String();
    _polls[orderId] = 0;
    return BookingDtos.session(o);
  }

  @override
  Future<void> cancel(String orderId) async {
    await _wait();
    _order(orderId)['status'] = 'CANCELLED';
  }

  @override
  Stream<PaymentUpdate> paymentEvents(String orderId) => const Stream.empty();

  void _settle(Record o) {
    final digits = (o['orderId']! as String).substring(2);
    final now = _ledger.clock().toUtc();
    final status = switch (outcome) {
      PaymentStatus.failed => 'FAILED',
      PaymentStatus.refundPending => 'REFUND_PENDING',
      _ => 'SUCCESS',
    };
    o['status'] = status;
    _ledger.transactions.insert(0, {
      'id': 'GD-$digits',
      'orderCode': o['orderCode'],
      'title': o['typeName'],
      'amount': o['amount'],
      'method': 'QR',
      'status': status == 'REFUND_PENDING' ? 'REFUNDED' : status,
      'createdAt': now.toIso8601String(),
    });
    if (status == 'REFUND_PENDING') o['refundCode'] = 'TS-$digits';
    if (status != 'SUCCESS') {
      _ledger.notify(
        'PAYMENT',
        'Thanh toán chưa thành công',
        body: o['orderCode'] as String?,
      );
      return;
    }
    if (o['kind'] == 'PARKING') return _settleParking(o, digits, now);
    _ledger.notify(
      'PAYMENT',
      'Thanh toán thành công',
      body: '${o['typeName']} · ${o['orderCode']}',
      link: '/p/tickets/VE-$digits',
    );
    o['ticketId'] = 'VE-$digits';
    _ledger.tickets.insert(0, {
      'id': 'VE-$digits',
      'code': 'VE-$digits',
      'typeCode': o['typeCode'],
      'typeName': o['typeName'],
      'status': 'PAID',
      'price': o['amount'],
      'fromId': o['fromId'],
      'fromName': o['fromName'],
      'toId': o['toId'],
      'toName': o['toName'],
      'purchasedAt': now.toIso8601String(),
      'validFrom': now.toIso8601String(),
      'validUntil': _validUntil(
        o['typeCode']! as String,
        now,
      ).toIso8601String(),
      'qrToken': 'tk_$digits${now.millisecondsSinceEpoch % 9973}',
    });
  }

  /// Đơn gửi xe (tạo bởi Fake gửi xe, dùng chung luồng thanh toán).
  void _settleParking(Record o, String digits, DateTime now) {
    final id = 'GX-$digits';
    o['parkingId'] = id;
    _ledger.parking.insert(0, {
      'id': id,
      'lotName': o['lotName'],
      'plate': o['plate'],
      'vehicle': o['vehicle'],
      'status': 'CHUA_GUI',
      'validUntil': now
          .add(Duration(hours: o['validHours']! as int))
          .toIso8601String(),
      'qrToken': 'pk_$digits',
    });
    _ledger.notify(
      'PAYMENT',
      'Đăng ký gửi xe thành công',
      body: '${o['plate']} · ${o['lotName']}',
      link: '/p/tickets/parking/$id',
    );
  }

  /// Vé lượt/ngày: hết 23:59 hôm nay (giờ VN = UTC+7).
  DateTime _validUntil(String type, DateTime nowUtc) {
    final vn = nowUtc.add(const Duration(hours: 7));
    final endOfDay = DateTime.utc(vn.year, vn.month, vn.day, 16, 59);
    return switch (type) {
      'THREE_DAY' => nowUtc.add(const Duration(days: 3)),
      'MONTH' || 'MONTH_STUDENT' => nowUtc.add(const Duration(days: 30)),
      _ =>
        endOfDay.isAfter(nowUtc)
            ? endOfDay
            : endOfDay.add(const Duration(days: 1)),
    };
  }
}
