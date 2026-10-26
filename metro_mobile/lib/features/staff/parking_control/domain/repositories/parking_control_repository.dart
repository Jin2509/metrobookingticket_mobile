import 'package:metro_mobile/features/staff/parking_control/domain/entities/parking_control_entities.dart';

abstract interface class ParkingControlRepository {
  /// `POST /api/parking/check-qr`. 409 quá hạn / đổi trạng thái.
  Future<ParkingCheck> checkQr(String qrToken, String lotId);
  Future<List<ParkedVehicle>> getParked(String lotId);
  Future<LotStatus> getLotStatus(String lotId);
}
