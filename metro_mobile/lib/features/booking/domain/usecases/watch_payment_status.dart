import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/repositories/booking_repository.dart';

/// UC8-01 bước 3: theo dõi kết quả thanh toán.
class WatchPaymentStatus {
  const WatchPaymentStatus(this._repo);
  final BookingRepository _repo;

  Stream<PaymentUpdate> call(String orderId) =>
      _repo.watchPaymentStatus(orderId);
}
