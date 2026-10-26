import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';

abstract interface class BookingRepository {
  Future<FareTable> getFareTable();
  Future<OrderPreview> previewOrder(BookingRequest request);
  Future<PaymentSession> createPayment(
    BookingRequest request, {
    required bool usePoints,
  });
  Future<PaymentSession> getPayment(String orderId);

  /// QR hết hạn → tạo mã mới cho cùng đơn.
  Future<PaymentSession> renewPayment(String orderId);

  /// A3: hủy → không tạo vé.
  Future<void> cancelPayment(String orderId);

  /// WS `/user/queue/payments`, dự phòng poll 3s. Kết thúc ở trạng thái
  /// cuối (thành công, thất bại, hết hạn, hủy, hoàn tiền).
  Stream<PaymentUpdate> watchPaymentStatus(String orderId);
}
