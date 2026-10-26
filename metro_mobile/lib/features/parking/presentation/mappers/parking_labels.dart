import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/l10n/l10n.dart';

String parkingPackageLabel(AppLocalizations l, ParkingPackage p) => switch (p) {
  ParkingPackage.turn => l.packageTurn,
  ParkingPackage.day => l.packageDay,
  ParkingPackage.month => l.packageMonth,
};
