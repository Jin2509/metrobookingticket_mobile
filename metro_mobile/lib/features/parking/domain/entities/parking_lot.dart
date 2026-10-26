import 'package:flutter/foundation.dart';

/// Gói gửi xe (Lượt / Ngày / Tháng).
enum ParkingPackage {
  turn('TURN', 'Lượt'),
  day('DAY', 'Ngày'),
  month('MONTH', 'Tháng');

  ParkingPackage(this.code, this.label);
  final String code;
  final String label;
}

/// Chỗ trống theo loại xe (`parking_capacity`).
@immutable
class LotCapacity {
  const LotCapacity({
    required this.vehicle,
    required this.free,
    required this.total,
  });

  /// MOTORBIKE, BICYCLE, CAR.
  final String vehicle;
  final int free;
  final int total;

  bool get isFull => free <= 0;
}

/// Bãi gửi xe tại ga.
@immutable
class ParkingLot {
  const ParkingLot({
    required this.id,
    required this.name,
    required this.stationName,
    required this.capacities,
  });

  final String id;

  /// `Bãi PK1`.
  final String name;
  final String stationName;
  final List<LotCapacity> capacities;

  String get label => '$stationName – $name';

  LotCapacity? capacityOf(String vehicle) =>
      capacities.where((c) => c.vehicle == vehicle).firstOrNull;
}

/// Yêu cầu đăng ký gửi xe (UC10-01).
@immutable
class ParkingRequest {
  const ParkingRequest({
    required this.lotId,
    required this.vehicle,
    required this.plate,
    required this.package,
  });

  final String lotId;
  final String vehicle;
  final String plate;
  final ParkingPackage package;

  @override
  bool operator ==(Object other) =>
      other is ParkingRequest &&
      other.lotId == lotId &&
      other.vehicle == vehicle &&
      other.plate == plate &&
      other.package == package;

  @override
  int get hashCode => Object.hash(lotId, vehicle, plate, package);
}

/// Kết quả `POST /api/parking/bookings/preview`.
@immutable
class ParkingPreview {
  const ParkingPreview({
    required this.fee,
    required this.validHours,
    this.activePassId,
  });

  final int fee;
  final int validHours;

  /// A4: biển số đang có lượt gửi còn hiệu lực.
  final String? activePassId;
}
