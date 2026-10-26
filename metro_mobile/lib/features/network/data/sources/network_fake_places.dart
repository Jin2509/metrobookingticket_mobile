import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

/// Tiện ích, xe buýt, lối ra quanh một số ga (demo UC6).
abstract final class NetworkFakePlaces {
  static const amenities = <String, List<Amenity>>{
    'BT': [
      Amenity(name: 'Chợ Bến Thành', kind: AmenityKind.landmark, distanceM: 80),
      Amenity(name: 'ATM Vietcombank', kind: AmenityKind.atm, distanceM: 120),
      Amenity(name: 'Bãi xe Lê Lợi', kind: AmenityKind.parking, distanceM: 200),
    ],
    'TD': [
      Amenity(name: 'Bãi gửi xe PK2', kind: AmenityKind.parking, distanceM: 50),
      Amenity(
        name: 'Bệnh viện Lê Văn Việt',
        kind: AmenityKind.hospital,
        distanceM: 650,
      ),
    ],
    'BS': [
      Amenity(name: 'Vincom Ba Son', kind: AmenityKind.shop, distanceM: 150),
      Amenity(
        name: 'Nhà vệ sinh công cộng',
        kind: AmenityKind.toilet,
        distanceM: 60,
      ),
    ],
  };

  static const busStops = <String, List<BusStop>>{
    'BT': [
      BusStop(
        id: 'B-HN',
        name: 'Trạm Hàm Nghi',
        lat: 10.7712,
        lng: 106.7005,
        walkMinutes: 3,
        routes: ['01', '03', '19', '52', '93'],
      ),
      BusStop(
        id: 'B-TTBT',
        name: 'Trạm trung chuyển Bến Thành',
        lat: 10.7710,
        lng: 106.6967,
        walkMinutes: 4,
        routes: ['04', '18', '36', '65', '88'],
      ),
    ],
    'TD': [
      BusStop(
        id: 'B-VVN',
        name: 'Trạm Võ Văn Ngân',
        lat: 10.8492,
        lng: 106.7731,
        walkMinutes: 5,
        routes: ['08', '30', '99'],
      ),
    ],
    'ST': [
      BusStop(
        id: 'B-BXST',
        name: 'Bến xe Suối Tiên',
        lat: 10.8795,
        lng: 106.8130,
        walkMinutes: 2,
        routes: ['19', '33', '52', '99'],
      ),
    ],
  };

  static const exits = <String, List<String>>{
    'BT': ['Cửa 1 – Chợ Bến Thành', 'Cửa 2 – Lê Lợi', 'Cửa 3 – Hàm Nghi'],
    'TD': ['Cửa A – Võ Văn Ngân', 'Cửa B – Xa lộ Hà Nội'],
  };
}
