import 'package:flutter/foundation.dart';

enum StationStructure { underground, elevated, atGrade }

@immutable
class Station {
  const Station({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.lineIds,
    this.address,
    this.active = true,
    this.structure = StationStructure.elevated,
  });

  final String id;
  final String name;
  final double lat;
  final double lng;
  final List<String> lineIds;
  final String? address;

  /// `false`: ga chưa khai thác / ngừng hoạt động (UC5-03 A2).
  final bool active;
  final StationStructure structure;

  bool get isInterchange => lineIds.length > 1;

  String get structureLabel => switch (structure) {
    StationStructure.underground => 'Ngầm',
    StationStructure.elevated => 'Trên cao',
    StationStructure.atGrade => 'Mặt đất',
  };
}
