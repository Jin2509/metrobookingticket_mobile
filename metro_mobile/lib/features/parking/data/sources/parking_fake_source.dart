import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/booking/data/sources/booking_fake_catalog.dart';
import 'package:metro_mobile/features/parking/data/sources/parking_fake_lots.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/features/parking/domain/repositories/parking_repository.dart';

/// Gửi xe demo. Đơn ghi vào `DemoLedger.orders` (kind PARKING) để màn QR
/// thanh toán và Fake thanh toán xử lý chung với đơn vé.
class ParkingFakeSource implements ParkingRepository {
  ParkingFakeSource(
    this._ledger, {
    this.latency = const Duration(milliseconds: 300),
  });

  final DemoLedger _ledger;
  final Duration latency;

  Future<void> _wait() => Future<void>.delayed(latency);

  ParkingLot _lot(String id) =>
      ParkingFakeLots.lots.where((l) => l.id == id).firstOrNull ??
      (throw const NotFoundFailure('Không tìm thấy bãi xe'));

  String _norm(String plate) => plate.replaceAll(RegExp('[^A-Z0-9]'), '');

  @override
  Future<List<ParkingLot>> getLots() async {
    await _wait();
    return ParkingFakeLots.lots;
  }

  @override
  Future<ParkingPreview> preview(ParkingRequest r) async {
    await _wait();
    _lot(r.lotId);
    final plate = _norm(r.plate.toUpperCase());
    final active = _ledger.parking.where(
      (p) =>
          plate.isNotEmpty &&
          _norm(p['plate']! as String) == plate &&
          (p['status'] == 'CHUA_GUI' || p['status'] == 'DANG_GUI'),
    );
    return ParkingPreview(
      fee: ParkingFakeLots.fees[r.vehicle]![r.package.code]!,
      validHours: ParkingFakeLots.validHours[r.package.code]!,
      activePassId: active.firstOrNull?['id'] as String?,
    );
  }

  @override
  Future<String> createPayment(ParkingRequest r) async {
    final p = await preview(r);
    if (p.activePassId != null) {
      throw const ConflictFailure('Xe đang có lượt gửi còn hiệu lực');
    }
    final lot = _lot(r.lotId);
    if (lot.capacityOf(r.vehicle)?.isFull ?? true) {
      throw const ConflictFailure('Loại giữ xe đã hết chỗ');
    }
    final code = 'DH${_ledger.nextCode()}';
    _ledger.orders[code] = {
      'orderId': code,
      'orderCode': code,
      'kind': 'PARKING',
      'amount': p.fee,
      'status': 'PENDING',
      'typeName': 'Gửi xe · gói ${r.package.label.toLowerCase()}',
      'lotName': '${lot.name} · ${lot.stationName}',
      'plate': r.vehicle == 'BICYCLE' ? 'Xe đạp' : r.plate.toUpperCase(),
      'vehicle': r.vehicle,
      'validHours': p.validHours,
      'bank': BookingFakeCatalog.bank,
      'transferContent': code,
      'expiresAt': _ledger
          .clock()
          .toUtc()
          .add(const Duration(minutes: 10))
          .toIso8601String(),
    };
    return code;
  }
}
