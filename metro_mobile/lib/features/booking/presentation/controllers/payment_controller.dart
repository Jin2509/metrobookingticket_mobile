import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/booking/booking_providers.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';

@immutable
class PaymentState {
  const PaymentState({
    this.session,
    this.update,
    this.expired = false,
    this.cancelling = false,
    this.error,
  });

  final PaymentSession? session;

  /// Trạng thái mới nhất từ WS / poll.
  final PaymentUpdate? update;

  /// Hết 10 phút: QR vô hiệu, chờ "Tạo mã mới".
  final bool expired;
  final bool cancelling;
  final String? error;

  PaymentStatus get status => update?.status ?? PaymentStatus.pending;

  PaymentState copyWith({
    PaymentSession? session,
    PaymentUpdate? update,
    bool? expired,
    bool? cancelling,
    String? error,
  }) => PaymentState(
    session: session ?? this.session,
    update: update ?? this.update,
    expired: expired ?? this.expired,
    cancelling: cancelling ?? this.cancelling,
    error: error,
  );
}

final paymentControllerProvider = NotifierProvider.autoDispose
    .family<PaymentController, PaymentState, String>(PaymentController.new);

/// P31/P32: tải phiên, theo dõi trạng thái, hết hạn, tạo mã mới, hủy.
class PaymentController extends Notifier<PaymentState> {
  PaymentController(this.orderId);
  final String orderId;
  StreamSubscription<PaymentUpdate>? _sub;

  @override
  PaymentState build() {
    ref.onDispose(() => unawaited(_sub?.cancel()));
    unawaited(_load());
    return const PaymentState();
  }

  Future<void> _load() async {
    try {
      final session = await ref.read(createPaymentProvider).load(orderId);
      if (!ref.mounted) return;
      state = state.copyWith(session: session);
      _watch();
    } on Failure catch (f) {
      if (ref.mounted) state = state.copyWith(error: f.message);
    }
  }

  void _watch() {
    unawaited(_sub?.cancel());
    _sub = ref
        .read(watchPaymentStatusProvider)
        .call(orderId)
        .listen((u) => state = state.copyWith(update: u));
  }

  /// CountdownChip về 0.
  void expire() {
    unawaited(_sub?.cancel());
    state = state.copyWith(expired: true);
  }

  Future<void> renew() async {
    final session = await ref.read(createPaymentProvider).renew(orderId);
    if (!ref.mounted) return;
    state = PaymentState(session: session);
    _watch();
  }

  /// A3: hủy giao dịch, không tạo vé.
  Future<void> cancel() async {
    state = state.copyWith(cancelling: true);
    // Ngừng theo dõi trạng thái; không cần chờ hủy xong.
    unawaited(_sub?.cancel());
    await ref.read(createPaymentProvider).cancel(orderId);
  }
}
