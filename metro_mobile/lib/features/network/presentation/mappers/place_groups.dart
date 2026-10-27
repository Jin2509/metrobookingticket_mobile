import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nhóm lọc ở mục Quanh ga. Trạm xe buýt là một nhóm riêng.
enum PlaceGroup { bus, health, market, food, education, leisure, services }

PlaceGroup placeGroupOf(AmenityKind k) => switch (k) {
  AmenityKind.hospital => PlaceGroup.health,
  AmenityKind.market || AmenityKind.shop => PlaceGroup.market,
  AmenityKind.food => PlaceGroup.food,
  AmenityKind.school => PlaceGroup.education,
  AmenityKind.park || AmenityKind.landmark => PlaceGroup.leisure,
  AmenityKind.atm ||
  AmenityKind.parking ||
  AmenityKind.toilet => PlaceGroup.services,
};

String placeGroupLabel(AppLocalizations l, PlaceGroup g) => switch (g) {
  PlaceGroup.bus => l.placeBus,
  PlaceGroup.health => l.placeHealth,
  PlaceGroup.market => l.placeMarket,
  PlaceGroup.food => l.placeFood,
  PlaceGroup.education => l.placeEducation,
  PlaceGroup.leisure => l.placeLeisure,
  PlaceGroup.services => l.placeServices,
};

String amenityKindLabel(AppLocalizations l, AmenityKind k) => switch (k) {
  AmenityKind.hospital => l.kindHospital,
  AmenityKind.market => l.kindMarket,
  AmenityKind.shop => l.kindShop,
  AmenityKind.food => l.kindFood,
  AmenityKind.school => l.kindSchool,
  AmenityKind.park => l.kindPark,
  AmenityKind.landmark => l.kindLandmark,
  AmenityKind.atm => l.kindAtm,
  AmenityKind.parking => l.kindParking,
  AmenityKind.toilet => l.kindToilet,
};

IconData amenityIcon(AmenityKind k) => switch (k) {
  AmenityKind.hospital => LucideIcons.hospital,
  AmenityKind.market => LucideIcons.store,
  AmenityKind.shop => LucideIcons.shoppingBag,
  AmenityKind.food => LucideIcons.utensils,
  AmenityKind.school => LucideIcons.graduationCap,
  AmenityKind.park => LucideIcons.trees,
  AmenityKind.landmark => LucideIcons.landmark,
  AmenityKind.atm => LucideIcons.creditCard,
  AmenityKind.parking => LucideIcons.circleParking,
  AmenityKind.toilet => LucideIcons.toilet,
};

/// Một dòng ở mục Quanh ga: tiện ích hoặc trạm xe buýt.
sealed class NearbyPlace {
  const NearbyPlace();
  PlaceGroup get group;
  int get walkMinutes;

  /// Gộp tiện ích + trạm buýt, gần nhất trước.
  static List<NearbyPlace> of(StationDetail d) => [
    for (final b in d.busStops) BusPlace(b),
    for (final a in d.amenities) AmenityPlace(a),
  ]..sort((a, b) => a.walkMinutes.compareTo(b.walkMinutes));
}

class AmenityPlace extends NearbyPlace {
  const AmenityPlace(this.amenity);
  final Amenity amenity;

  @override
  PlaceGroup get group => placeGroupOf(amenity.kind);

  @override
  int get walkMinutes => amenity.walkMinutes;
}

class BusPlace extends NearbyPlace {
  const BusPlace(this.stop);
  final BusStop stop;

  @override
  PlaceGroup get group => PlaceGroup.bus;

  @override
  int get walkMinutes => stop.walkMinutes;
}
