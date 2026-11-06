import 'package:flutter/foundation.dart';

enum StationStructure { underground, elevated, atGrade }

/// `station.status`: `ACTIVE` | `INACTIVE` | `MAINTENANCE`.
enum StationStatus { active, inactive, maintenance }

@immutable
class Station {
  const Station({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.lineIds,
    this.code,
    this.address,
    this.district,
    this.imageUrl,
    this.status = StationStatus.active,
    this.structure,
  });

  final String id;

  /// Mã ga backend, VD `ST001`.
  final String? code;
  final String name;
  final double lat;
  final double lng;
  final List<String> lineIds;
  final String? address;
  final String? district;
  final String? imageUrl;
  final StationStatus status;

  /// `null`: backend chưa có thông tin kết cấu ga.
  final StationStructure? structure;

  /// `false`: ga tạm ngừng / bảo trì (UC5-03 A2).
  bool get active => status == StationStatus.active;
  bool get underMaintenance => status == StationStatus.maintenance;

  bool get isInterchange => lineIds.length > 1;

  /// Địa chỉ hiển thị: `address`, thiếu thì dùng `district`.
  String? get place => address ?? district;

  String? get structureLabel => switch (structure) {
    StationStructure.underground => 'Ngầm',
    StationStructure.elevated => 'Trên cao',
    StationStructure.atGrade => 'Mặt đất',
    null => null,
  };

  Station copyWith({List<String>? lineIds}) => Station(
    id: id,
    code: code,
    name: name,
    lat: lat,
    lng: lng,
    lineIds: lineIds ?? this.lineIds,
    address: address,
    district: district,
    imageUrl: imageUrl,
    status: status,
    structure: structure,
  );
}
