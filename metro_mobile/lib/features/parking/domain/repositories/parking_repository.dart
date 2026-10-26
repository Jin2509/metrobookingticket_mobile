import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';

abstract interface class ParkingRepository {
  Future<List<ParkingLot>> getLots();
  Future<ParkingPreview> preview(ParkingRequest request);

  /// Tạo đơn gửi xe, trả `orderId` để dùng chung màn QR thanh toán.
  Future<String> createPayment(ParkingRequest request);
}
