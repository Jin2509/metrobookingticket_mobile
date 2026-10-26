import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Loại xe gửi (P35, P42).
enum VehicleKind {
  motorbike(LucideIcons.motorbike),
  bicycle(LucideIcons.bike),
  car(LucideIcons.carFront);

  VehicleKind(this.icon);
  final IconData icon;

  String label(AppLocalizations l) => switch (this) {
    motorbike => l.vehicleMotorbike,
    bicycle => l.vehicleBicycle,
    car => l.vehicleCar,
  };
}

/// Mã loại xe backend (`MOTORBIKE`, `CAR`, `BICYCLE`) → nhãn. Mã lạ giữ nguyên.
String vehicleCodeLabel(AppLocalizations l, String code) => switch (code) {
  'MOTORBIKE' => l.vehicleMotorbike,
  'CAR' => l.vehicleCar,
  'BICYCLE' => l.vehicleBicycle,
  _ => code,
};
