import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/qr/qr_payload.dart';
import 'package:metro_mobile/core/utils/vn_text.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/entities/parking_control_entities.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/repositories/parking_control_repository.dart';

/// UC10-03: quét QR gửi xe tại bãi phụ trách. QR vé → sai loại.
class CheckParkingQr {
  const CheckParkingQr(this._repo);
  final ParkingControlRepository _repo;

  Future<ParkingCheck> call(QrPayload p, String lotId) {
    if (p.kind != QrKind.parking) {
      throw const ValidationFailure('Mã QR không đúng loại');
    }
    return _repo.checkQr(p.token, lotId);
  }
}

/// Xe đang gửi, lọc theo biển số (bỏ dấu, không phân biệt hoa thường).
class GetParkedVehicles {
  const GetParkedVehicles(this._repo);
  final ParkingControlRepository _repo;

  Future<List<ParkedVehicle>> call(String lotId, {String query = ''}) async {
    final list = await _repo.getParked(lotId);
    final q = query.replaceAll(RegExp(r'[\s.\-]'), '');
    if (q.isEmpty) return list;
    return list
        .where((v) => vnContains(v.plate.replaceAll(RegExp(r'[.\-]'), ''), q))
        .toList();
  }
}
