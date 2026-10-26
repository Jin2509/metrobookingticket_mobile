import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

/// Icon theo loại tiện ích quanh ga.
const amenityIcons = <AmenityKind, IconData>{
  AmenityKind.atm: LucideIcons.creditCard,
  AmenityKind.food: LucideIcons.utensils,
  AmenityKind.shop: LucideIcons.store,
  AmenityKind.parking: LucideIcons.circleParking,
  AmenityKind.toilet: LucideIcons.toilet,
  AmenityKind.hospital: LucideIcons.hospital,
  AmenityKind.landmark: LucideIcons.landmark,
};
