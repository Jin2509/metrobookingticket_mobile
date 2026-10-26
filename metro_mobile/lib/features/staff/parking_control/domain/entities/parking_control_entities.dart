import 'package:flutter/foundation.dart';

/// Kết quả quét QR gửi xe: chuyển trạng thái (S21).
/// `CHUA_GUI → DANG_GUI` khi xe vào, `DANG_GUI → LAY_XE` khi xe ra.
@immutable
class ParkingCheck {
  const ParkingCheck({
    required this.plate,
    required this.vehicle,
    required this.fromStatus,
    required this.toStatus,
    required this.at,
  });

  final String plate;
  final String vehicle;
  final String fromStatus;
  final String toStatus;
  final DateTime at;

  bool get isEntry => toStatus == 'DANG_GUI';
}

/// Xe đang gửi tại bãi.
@immutable
class ParkedVehicle {
  const ParkedVehicle({required this.plate, required this.vehicle, this.since});

  final String plate;
  final String vehicle;
  final DateTime? since;
}

/// `Sức chứa: Xe máy 640/800 · Ô tô 41/60`.
@immutable
class LotStatus {
  const LotStatus({required this.lotName, required this.usage});

  final String lotName;

  /// (loại xe, đang gửi, tổng chỗ).
  final List<(String, int, int)> usage;
}
