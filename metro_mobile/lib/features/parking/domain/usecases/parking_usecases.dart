import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/domain/repositories/parking_repository.dart';

/// Biển số VN: `59X1-234.56`, `51G-888.88`, `51G-88888`, `59X123456`.
final _plate = RegExp(r'^\d{2}[A-Z]{1,2}\d?-?\d{3}\.?\d{2}$');

const bicycle = 'BICYCLE';

/// `null` nếu hợp lệ. Xe đạp không cần biển số.
String? validatePlate(String vehicle, String plate) {
  if (vehicle == bicycle) return null;
  final p = plate.trim().toUpperCase();
  if (p.isEmpty) return 'Vui lòng nhập biển số';
  return _plate.hasMatch(p) ? null : 'Biển số không đúng định dạng';
}

class GetParkingLots {
  const GetParkingLots(this._repo);
  final ParkingRepository _repo;

  Future<List<ParkingLot>> call() => _repo.getLots();
}

/// UC10-01: phí + kiểm tra lượt còn hiệu lực (A4). A1 biển số sai.
class PreviewParking {
  const PreviewParking(this._repo);
  final ParkingRepository _repo;

  Future<ParkingPreview> call(ParkingRequest r) {
    final error = validatePlate(r.vehicle, r.plate);
    if (error != null) throw ValidationFailure(error);
    return _repo.preview(r);
  }
}

/// Tạo thanh toán gửi xe. A3 hết chỗ → `ConflictFailure`.
class CreateParkingPayment {
  const CreateParkingPayment(this._repo);
  final ParkingRepository _repo;

  Future<String> call(ParkingRequest r) {
    final error = validatePlate(r.vehicle, r.plate);
    if (error != null) throw ValidationFailure(error);
    return _repo.createPayment(r);
  }
}
