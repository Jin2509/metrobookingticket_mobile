import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:metro_mobile/features/booking/data/sources/booking_fake_source.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/usecases/preview_order.dart';
import 'package:metro_mobile/features/network/data/repositories/network_repository_impl.dart';
import 'package:metro_mobile/features/network/data/sources/network_fake_source.dart';
import 'package:metro_mobile/features/wallet/data/sources/wallet_fake_source.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';

const _single = BookingRequest(typeCode: 'SINGLE', fromId: 'BT', toId: 'TD');

void main() {
  late DemoLedger ledger;
  BookingRepositoryImpl repo({PaymentStatus outcome = PaymentStatus.success}) =>
      BookingRepositoryImpl(
        BookingFakeSource(
          ledger: ledger,
          network: NetworkRepositoryImpl(
            NetworkFakeSource(latency: Duration.zero),
          ),
          latency: Duration.zero,
          outcome: outcome,
        ),
      );

  setUp(() => ledger = DemoLedger());

  test('giá vé lượt: ưu đãi 20%, hạng Bạc 5%, đổi 100 điểm', () async {
    final p = await PreviewOrder(repo())(_single);
    expect(p.basePrice, 12000);
    expect(p.discounts.map((d) => d.amount), [2400, 480]);
    expect(p.total(usePoints: false), 9120);
    expect(p.total(usePoints: true), 8120);
    expect(p.fromName, 'Bến Thành');
  });

  test('vé tháng không cần chọn ga, chỉ giảm theo hạng', () async {
    final p = await PreviewOrder(repo())(
      const BookingRequest(typeCode: 'MONTH'),
    );
    expect(p.basePrice, 300000);
    expect(p.total(usePoints: false), 285000);
    expect(p.fromName, isNull);
  });

  test('A1: thiếu ga, trùng ga, ga chưa hoạt động', () {
    final preview = PreviewOrder(repo());
    expect(
      () => preview(const BookingRequest(typeCode: 'SINGLE', fromId: 'BT')),
      throwsA(isA<ValidationFailure>()),
    );
    expect(
      () => preview(
        const BookingRequest(typeCode: 'SINGLE', fromId: 'BT', toId: 'BT'),
      ),
      throwsA(isA<ValidationFailure>()),
    );
    expect(
      preview(
        const BookingRequest(typeCode: 'SINGLE', fromId: 'TDN', toId: 'TD'),
      ),
      throwsA(
        isA<ValidationFailure>().having(
          (f) => f.message,
          'message',
          'Ga Tao Đàn chưa hoạt động',
        ),
      ),
    );
  });

  test('thanh toán thành công sau ~3s: tạo vé, Vé của tôi thấy ngay', () {
    fakeAsync((async) {
      final r = repo();
      late PaymentSession session;
      unawaited(
        r.createPayment(_single, usePoints: true).then((s) => session = s),
      );
      async.elapse(const Duration(milliseconds: 10));
      expect(session.amount, 8120);
      expect(session.expiresAt.difference(DateTime.now().toUtc()).inMinutes, 9);

      final updates = <PaymentUpdate>[];
      var done = false;
      r
          .watchPaymentStatus(session.orderId)
          .listen(updates.add, onDone: () => done = true);
      async.flushMicrotasks();
      expect(updates.single.status, PaymentStatus.pending);
      async.elapse(const Duration(seconds: 3));
      expect(updates.last.status, PaymentStatus.success);
      async.elapse(const Duration(milliseconds: 10));
      expect(done, isTrue, reason: 'stream kết thúc ở trạng thái cuối');

      final ticketId = updates.last.ticketId!;
      unawaited(
        WalletFakeSource(ledger, latency: Duration.zero)
            .getMyTickets(TicketFilter.unused, 0, 20)
            .then((page) => expect(page.items.first.id, ticketId)),
      );
      async.elapse(const Duration(milliseconds: 10));
    });
  });

  test('A2 thất bại / A4 hoàn tiền: không tạo vé, có mã tra soát', () {
    for (final outcome in [PaymentStatus.failed, PaymentStatus.refundPending]) {
      fakeAsync((async) {
        final before = ledger.tickets.length;
        final r = repo(outcome: outcome);
        PaymentUpdate? last;
        unawaited(
          r
              .createPayment(_single, usePoints: false)
              .then(
                (s) => r.watchPaymentStatus(s.orderId).listen((u) => last = u),
              ),
        );
        async.elapse(const Duration(seconds: 4));
        expect(last!.status, outcome);
        expect(ledger.tickets.length, before);
        if (outcome == PaymentStatus.refundPending) {
          expect(last!.refundCode, startsWith('TS-'));
        }
      });
    }
  });

  test('A3 hủy giao dịch: đơn chuyển CANCELLED, không tạo vé', () async {
    final r = repo();
    final before = ledger.tickets.length;
    final s = await r.createPayment(_single, usePoints: false);
    await r.cancelPayment(s.orderId);
    expect(ledger.orders[s.orderId]!['status'], 'CANCELLED');
    expect(ledger.tickets.length, before);
  });
}
