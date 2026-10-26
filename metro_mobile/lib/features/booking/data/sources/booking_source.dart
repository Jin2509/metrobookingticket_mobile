import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';

/// Lời gọi API thô của đặt vé (remote hoặc fake).
abstract interface class BookingSource {
  Future<FareTable> fetchFareTable();
  Future<OrderPreview> preview(BookingRequest r);
  Future<PaymentSession> createPayment(
    BookingRequest r, {
    required bool usePoints,
  });
  Future<PaymentSession> fetchSession(String orderId);

  /// Poll trạng thái (dự phòng khi WS chậm hoặc mất).
  Future<PaymentUpdate> fetchStatus(String orderId);
  Future<PaymentSession> renew(String orderId);
  Future<void> cancel(String orderId);

  /// Đẩy từ WS `/user/queue/payments`.
  Stream<PaymentUpdate> paymentEvents(String orderId);
}
