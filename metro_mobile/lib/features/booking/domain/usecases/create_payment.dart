import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/domain/repositories/booking_repository.dart';

/// UC8-01 bước 2: tạo đơn + QR thanh toán; hết hạn thì tạo mã mới; hủy.
class CreatePayment {
  const CreatePayment(this._repo);
  final BookingRepository _repo;

  Future<PaymentSession> call(BookingRequest r, {required bool usePoints}) =>
      _repo.createPayment(r, usePoints: usePoints);

  Future<PaymentSession> load(String orderId) => _repo.getPayment(orderId);

  Future<PaymentSession> renew(String orderId) => _repo.renewPayment(orderId);

  Future<void> cancel(String orderId) => _repo.cancelPayment(orderId);
}
