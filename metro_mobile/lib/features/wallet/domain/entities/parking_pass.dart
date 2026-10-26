import 'package:flutter/foundation.dart';

/// Lượt gửi xe đang hiệu lực (UC10-02, P42).
@immutable
class ParkingPass {
  const ParkingPass({
    required this.id,
    required this.lotName,
    required this.plate,
    required this.vehicleCode,
    required this.status,
    required this.validUntil,
    required this.qrToken,
    this.since,
  });

  final String id;
  final String lotName;
  final String plate;

  /// MOTORBIKE, BICYCLE, CAR.
  final String vehicleCode;

  /// CHUA_GUI, DANG_GUI, LAY_XE, HET_HAN.
  final String status;
  final DateTime validUntil;
  final String qrToken;
  final DateTime? since;

  bool get isUsable => status == 'CHUA_GUI' || status == 'DANG_GUI';
}
