import 'dart:async';

import 'package:metro_mobile/features/booking/data/sources/booking_source.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';
import 'package:metro_mobile/features/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(
    this._source, {
    this.pollInterval = const Duration(seconds: 3),
  });

  final BookingSource _source;
  final Duration pollInterval;
  FareTable? _fares;

  @override
  Future<FareTable> getFareTable() async =>
      _fares ??= await _source.fetchFareTable();

  @override
  Future<OrderPreview> previewOrder(BookingRequest request) =>
      _source.preview(request);

  @override
  Future<PaymentSession> createPayment(
    BookingRequest request, {
    required bool usePoints,
  }) => _source.createPayment(request, usePoints: usePoints);

  @override
  Future<PaymentSession> getPayment(String orderId) =>
      _source.fetchSession(orderId);

  @override
  Future<PaymentSession> renewPayment(String orderId) => _source.renew(orderId);

  @override
  Future<void> cancelPayment(String orderId) => _source.cancel(orderId);

  /// WS là nguồn chính, poll [pollInterval] là dự phòng. Gặp trạng thái
  /// cuối thì hủy cả WS lẫn timer poll rồi đóng stream.
  @override
  Stream<PaymentUpdate> watchPaymentStatus(String orderId) {
    late final StreamController<PaymentUpdate> ctrl;
    StreamSubscription<PaymentUpdate>? ws;
    Timer? timer;

    void emit(PaymentUpdate u) {
      if (ctrl.isClosed) return;
      ctrl.add(u);
      if (!u.status.isTerminal) return;
      timer?.cancel();
      unawaited(ws?.cancel());
      unawaited(ctrl.close());
    }

    Future<void> poll() async {
      try {
        emit(await _source.fetchStatus(orderId));
      } on Object {
        // Lỗi mạng tạm thời: chờ lần poll sau.
      }
    }

    ctrl = StreamController<PaymentUpdate>(
      onListen: () {
        ws = _source.paymentEvents(orderId).listen(emit, onError: (_) {});
        timer = Timer.periodic(pollInterval, (_) => unawaited(poll()));
        unawaited(poll());
      },
      // Không trả future của ws.cancel(): đóng stream không cần chờ WS.
      onCancel: () {
        timer?.cancel();
        unawaited(ws?.cancel());
      },
    );
    return ctrl.stream;
  }
}
