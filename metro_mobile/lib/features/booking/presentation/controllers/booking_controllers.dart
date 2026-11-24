import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/booking/booking_providers.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';

/// P34 + chip loại vé ở Trang chủ (cache trong phiên).
final fareTableProvider = FutureProvider<FareTable>(
  (ref) => ref.watch(getFareTableProvider).call(),
);

final orderPreviewProvider = FutureProvider.autoDispose
    .family<OrderPreview, BookingRequest>(
      (ref, r) => ref.watch(previewOrderProvider).call(r),
    );

@immutable
class BookingFormState {
  const BookingFormState({
    this.submitting = false,
    this.error,
    this.mockPay = false,
  });

  final bool submitting;
  final String? error;

  /// Chọn "Thanh toán giả" (chỉ hiện ở bản dev).
  final bool mockPay;
}

final bookingControllerProvider = NotifierProvider.autoDispose
    .family<BookingController, BookingFormState, BookingRequest>(
      BookingController.new,
    );

/// P30: tạo thanh toán (khóa nút khi đang gửi).
class BookingController extends Notifier<BookingFormState> {
  BookingController(this.request);
  final BookingRequest request;

  @override
  BookingFormState build() => const BookingFormState();

  /// Thanh toán giả chỉ có ở bản dev; bản khác luôn đi VietQR.
  void setMockPay({required bool value}) {
    if (!Env.isDev || state.submitting) return;
    state = BookingFormState(mockPay: value);
  }

  Future<PaymentStart?> pay() async {
    if (state.submitting) return null;
    final mock = Env.isDev && state.mockPay;
    state = BookingFormState(submitting: true, mockPay: mock);
    try {
      final start = await ref
          .read(createPaymentProvider)
          .call(request, mock: mock);
      if (ref.mounted) state = BookingFormState(mockPay: mock);
      return start;
    } on Failure catch (f) {
      if (ref.mounted) {
        state = BookingFormState(error: f.message, mockPay: mock);
      }
      return null;
    }
  }
}
