import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/entities/parking_control_entities.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/repositories/parking_control_repository.dart';
import 'package:metro_mobile/features/staff/staff_demo.dart';

/// Gửi xe tại bãi demo: lượt gửi do Passenger đăng ký (cùng `DemoLedger`)
/// và lượt mẫu. Chỉ xử lý lượt thuộc bãi phụ trách.
class ParkingControlFakeSource implements ParkingControlRepository {
  ParkingControlFakeSource(
    this._ledger, {
    this.latency = const Duration(milliseconds: 250),
  });

  final DemoLedger _ledger;
  final Duration latency;

  Iterable<Record> get _atLot => [
    ..._ledger.parking,
    ..._ledger.sampleParking,
  ].where((p) => p['lotName'] == StaffDemo.lotName);

  @override
  Future<ParkingCheck> checkQr(String qrToken, String lotId) async {
    await Future<void>.delayed(latency);
    final now = _ledger.clock();
    final p = _ledger.findParking(qrToken);
    String? error;
    if (p == null) {
      error = 'Không tìm thấy lượt gửi xe';
    } else if (p['lotName'] != StaffDemo.lotName) {
      error = 'Lượt gửi xe thuộc bãi khác';
    }
    if (error != null) {
      _log(now, p, valid: false, label: error, entry: true);
      throw NotFoundFailure(error);
    }
    final from = p!['status']! as String;
    final expired = DateTime.parse(p['validUntil']! as String).isBefore(now);
    if (from == 'LAY_XE' || (from == 'CHUA_GUI' && expired)) {
      final msg = from == 'LAY_XE'
          ? 'Lượt gửi xe đã kết thúc'
          : 'Đăng ký gửi xe đã quá hạn';
      _log(now, p, valid: false, label: msg, entry: from == 'CHUA_GUI');
      throw ConflictFailure(msg);
    }
    final to = from == 'CHUA_GUI' ? 'DANG_GUI' : 'LAY_XE';
    p['status'] = to;
    if (to == 'DANG_GUI') p['since'] = now.toUtc().toIso8601String();
    _log(
      now,
      p,
      valid: true,
      label: to == 'DANG_GUI' ? 'Xe vào' : 'Xe ra',
      entry: to == 'DANG_GUI',
    );
    return ParkingCheck(
      plate: p['plate']! as String,
      vehicle: p['vehicle']! as String,
      fromStatus: from,
      toStatus: to,
      at: now,
    );
  }

  void _log(
    DateTime at,
    Record? p, {
    required bool valid,
    required String label,
    required bool entry,
  }) => _ledger.scanLog.insert(0, {
    'at': at.toUtc().toIso8601String(),
    'parking': true,
    'entry': entry,
    'code': p?['plate'] ?? '—',
    'valid': valid,
    'label': label,
  });

  @override
  Future<List<ParkedVehicle>> getParked(String lotId) async {
    await Future<void>.delayed(latency);
    return [
      for (final p in _atLot)
        if (p['status'] == 'DANG_GUI')
          ParkedVehicle(
            plate: p['plate']! as String,
            vehicle: p['vehicle']! as String,
            since: p['since'] == null
                ? null
                : DateTime.parse(p['since']! as String),
          ),
    ];
  }

  @override
  Future<LotStatus> getLotStatus(String lotId) async {
    int parked(String v) => _atLot
        .where((p) => p['vehicle'] == v && p['status'] == 'DANG_GUI')
        .length;
    return LotStatus(
      lotName: StaffDemo.lotName,
      usage: [
        ('MOTORBIKE', 639 + parked('MOTORBIKE'), 800),
        ('CAR', 41 + parked('CAR'), 60),
      ],
    );
  }
}
