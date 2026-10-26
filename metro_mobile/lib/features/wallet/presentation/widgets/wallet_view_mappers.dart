import 'package:metro_mobile/design_system/design_system.dart';

/// Mã loại xe backend → `VehicleKind` của design system.
VehicleKind vehicleKindOf(String code) => switch (code) {
  'BICYCLE' => VehicleKind.bicycle,
  'CAR' => VehicleKind.car,
  _ => VehicleKind.motorbike,
};
