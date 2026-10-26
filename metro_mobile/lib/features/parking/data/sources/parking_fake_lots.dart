import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';

/// Bãi xe + biểu phí demo. Ô tô ở Suối Tiên hết chỗ để demo A3.
abstract final class ParkingFakeLots {
  static const lots = [
    ParkingLot(
      id: 'PK1-ST',
      name: 'Bãi PK1',
      stationName: 'Suối Tiên',
      capacities: [
        LotCapacity(vehicle: 'MOTORBIKE', free: 312, total: 1200),
        LotCapacity(vehicle: 'BICYCLE', free: 80, total: 200),
        LotCapacity(vehicle: 'CAR', free: 0, total: 40),
      ],
    ),
    ParkingLot(
      id: 'PK2-TD',
      name: 'Bãi PK2',
      stationName: 'Thủ Đức',
      capacities: [
        LotCapacity(vehicle: 'MOTORBIKE', free: 160, total: 800),
        LotCapacity(vehicle: 'BICYCLE', free: 50, total: 100),
        LotCapacity(vehicle: 'CAR', free: 19, total: 60),
      ],
    ),
    ParkingLot(
      id: 'PK1-AP',
      name: 'Bãi PK1',
      stationName: 'An Phú',
      capacities: [
        LotCapacity(vehicle: 'MOTORBIKE', free: 220, total: 400),
        LotCapacity(vehicle: 'BICYCLE', free: 30, total: 60),
      ],
    ),
  ];

  /// Phí theo loại xe × gói (₫).
  static const fees = {
    'MOTORBIKE': {'TURN': 5000, 'DAY': 10000, 'MONTH': 150000},
    'BICYCLE': {'TURN': 2000, 'DAY': 5000, 'MONTH': 60000},
    'CAR': {'TURN': 25000, 'DAY': 50000, 'MONTH': 1200000},
  };

  static const validHours = {'TURN': 12, 'DAY': 24, 'MONTH': 720};
}
