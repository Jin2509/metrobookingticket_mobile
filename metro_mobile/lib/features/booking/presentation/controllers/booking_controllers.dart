import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    this.usePoints = false,
    this.submitting = false,
    this.error,
  });

  final bool usePoints;
  final bool submitting;
  final String? error;
}

final bookingControllerProvider = NotifierProvider.autoDispose
    .family<BookingController, BookingFormState, BookingRequest>(
      BookingController.new,
    );

/// P30: dùng điểm, tạo thanh toán (khóa nút khi đang gửi).
class BookingController extends Notifier<BookingFormState> {
  BookingController(this.request);
  final BookingRequest request;

  @override
  BookingFormState build() => const BookingFormState();

  void togglePoints() => state = BookingFormState(usePoints: !state.usePoints);

  Future<PaymentSession?> pay() async {
    if (state.submitting) return null;
    final usePoints = state.usePoints;
    state = BookingFormState(usePoints: usePoints, submitting: true);
    try {
      final session = await ref
          .read(createPaymentProvider)
          .call(request, usePoints: usePoints);
      if (ref.mounted) state = BookingFormState(usePoints: usePoints);
      return session;
    } on Failure catch (f) {
      if (ref.mounted) {
        state = BookingFormState(usePoints: usePoints, error: f.message);
      }
      return null;
    }
  }
}
