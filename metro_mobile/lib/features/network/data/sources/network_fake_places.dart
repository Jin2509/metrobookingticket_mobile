import 'package:metro_mobile/features/network/domain/entities/station_detail.dart';

const _hospital = AmenityKind.hospital;
const _market = AmenityKind.market;
const _shop = AmenityKind.shop;
const _food = AmenityKind.food;
const _school = AmenityKind.school;
const _park = AmenityKind.park;
const _landmark = AmenityKind.landmark;
const _atm = AmenityKind.atm;
const _parking = AmenityKind.parking;
const _toilet = AmenityKind.toilet;

/// Tiện ích, xe buýt, lối ra quanh các ga Tuyến 1 (demo UC6). Tên địa
/// điểm và khoảng cách là minh họa, bản thật đọc từ `/api/stations/{id}`.
abstract final class NetworkFakePlaces {
  static const amenities = <String, List<Amenity>>{
    'BT': [
      Amenity(name: 'Chợ Bến Thành', kind: _market, distanceM: 80),
      Amenity(name: 'Bệnh viện Sài Gòn', kind: _hospital, distanceM: 350),
      Amenity(name: 'Saigon Centre', kind: _shop, distanceM: 250),
      Amenity(name: 'Công viên 23 Tháng 9', kind: _park, distanceM: 200),
      Amenity(name: 'Phở Hòa Pasteur', kind: _food, distanceM: 700),
      Amenity(name: 'ATM Vietcombank', kind: _atm, distanceM: 120),
      Amenity(name: 'Bãi xe Lê Lợi', kind: _parking, distanceM: 200),
    ],
    'NHTP': [
      Amenity(name: 'Nhà hát Thành phố', kind: _landmark, distanceM: 50),
      Amenity(name: 'Phố đi bộ Nguyễn Huệ', kind: _landmark, distanceM: 250),
      Amenity(name: 'Vincom Center Đồng Khởi', kind: _shop, distanceM: 200),
      Amenity(name: 'Bệnh viện Nhi đồng 2', kind: _hospital, distanceM: 900),
      Amenity(name: 'Nhà vệ sinh công cộng', kind: _toilet, distanceM: 150),
    ],
    'BS': [
      Amenity(name: 'Vincom Ba Son', kind: _shop, distanceM: 150),
      Amenity(name: 'Công viên Bến Bạch Đằng', kind: _park, distanceM: 300),
      Amenity(name: 'Chợ Tân Định', kind: _market, distanceM: 1200),
      Amenity(name: 'Nhà vệ sinh công cộng', kind: _toilet, distanceM: 60),
    ],
    'VT': [
      Amenity(name: 'Khu du lịch Văn Thánh', kind: _park, distanceM: 250),
      Amenity(name: 'Chợ Văn Thánh', kind: _market, distanceM: 450),
      Amenity(name: 'ĐH Ngoại thương cơ sở 2', kind: _school, distanceM: 600),
      Amenity(name: 'Bệnh viện Ung bướu', kind: _hospital, distanceM: 1100),
    ],
    'TC': [
      Amenity(name: 'Landmark 81', kind: _shop, distanceM: 450),
      Amenity(
        name: 'Công viên Vinhomes Central Park',
        kind: _park,
        distanceM: 400,
      ),
      Amenity(
        name: 'Bệnh viện Vinmec Central Park',
        kind: _hospital,
        distanceM: 650,
      ),
      Amenity(name: 'Bãi gửi xe Tân Cảng', kind: _parking, distanceM: 80),
    ],
    'TDI': [
      Amenity(name: 'Chợ Thảo Điền', kind: _market, distanceM: 500),
      Amenity(name: 'Trường Quốc tế Anh BIS', kind: _school, distanceM: 750),
      Amenity(name: 'Phố ẩm thực Xuân Thủy', kind: _food, distanceM: 600),
      Amenity(name: 'ATM Techcombank', kind: _atm, distanceM: 300),
    ],
    'AP': [
      Amenity(name: 'MM Mega Market An Phú', kind: _shop, distanceM: 400),
      Amenity(name: 'Chợ An Phú', kind: _market, distanceM: 700),
      Amenity(name: 'Bệnh viện Quận 2 cũ', kind: _hospital, distanceM: 1300),
      Amenity(name: 'Bãi gửi xe An Phú', kind: _parking, distanceM: 60),
    ],
    'RC': [
      Amenity(name: 'Sân vận động Rạch Chiếc', kind: _park, distanceM: 900),
      Amenity(name: 'Chợ Bình Trưng', kind: _market, distanceM: 1100),
      Amenity(name: 'ATM Agribank', kind: _atm, distanceM: 350),
    ],
    'PL': [
      Amenity(name: 'Chợ Phước Long', kind: _market, distanceM: 600),
      Amenity(name: 'Trường THPT Phước Long', kind: _school, distanceM: 800),
      Amenity(name: 'Bãi gửi xe Phước Long', kind: _parking, distanceM: 50),
    ],
    'BTH': [
      Amenity(name: 'Chợ Bình Thái', kind: _market, distanceM: 400),
      Amenity(name: 'ĐH Tài chính – Marketing', kind: _school, distanceM: 1200),
      Amenity(name: 'Quán ăn Xa lộ Hà Nội', kind: _food, distanceM: 250),
    ],
    'TD': [
      Amenity(name: 'Bãi gửi xe PK2', kind: _parking, distanceM: 50),
      Amenity(name: 'Bệnh viện TP. Thủ Đức', kind: _hospital, distanceM: 650),
      Amenity(name: 'Chợ Thủ Đức', kind: _market, distanceM: 900),
      Amenity(name: 'Vincom Plaza Thủ Đức', kind: _shop, distanceM: 500),
      Amenity(name: 'ĐH Sư phạm Kỹ thuật', kind: _school, distanceM: 1000),
    ],
    'CNC': [
      Amenity(name: 'Khu Công nghệ cao', kind: _landmark, distanceM: 300),
      Amenity(name: 'Trường ĐH FPT', kind: _school, distanceM: 1500),
      Amenity(name: 'Căn tin khu CNC', kind: _food, distanceM: 400),
    ],
    'DHQG': [
      Amenity(name: 'Đại học Quốc gia TP.HCM', kind: _school, distanceM: 300),
      Amenity(name: 'Bệnh viện ĐHQG', kind: _hospital, distanceM: 1400),
      Amenity(name: 'Chợ Nông Lâm', kind: _market, distanceM: 800),
      Amenity(name: 'Nhà vệ sinh công cộng', kind: _toilet, distanceM: 40),
    ],
    'ST': [
      Amenity(name: 'Khu du lịch Suối Tiên', kind: _park, distanceM: 250),
      Amenity(name: 'Bến xe Miền Đông mới', kind: _landmark, distanceM: 700),
      Amenity(name: 'Chợ Suối Tiên', kind: _market, distanceM: 600),
      Amenity(name: 'Bãi gửi xe PK1', kind: _parking, distanceM: 60),
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
    'NHTP': [
      BusStop(
        id: 'B-DK',
        name: 'Trạm Đồng Khởi',
        lat: 10.7770,
        lng: 106.7020,
        walkMinutes: 2,
        routes: ['03', '19', '45'],
      ),
    ],
    'BS': [
      BusStop(
        id: 'B-TDT',
        name: 'Trạm Tôn Đức Thắng',
        lat: 10.7822,
        lng: 106.7062,
        walkMinutes: 3,
        routes: ['19', '56', '88'],
      ),
    ],
    'VT': [
      BusStop(
        id: 'B-DBP',
        name: 'Trạm Điện Biên Phủ',
        lat: 10.7955,
        lng: 106.7150,
        walkMinutes: 4,
        routes: ['10', '52', '56'],
      ),
    ],
    'TC': [
      BusStop(
        id: 'B-L81',
        name: 'Trạm Landmark 81',
        lat: 10.7950,
        lng: 106.7220,
        walkMinutes: 6,
        routes: ['56', '93', '150'],
      ),
    ],
    'TDI': [
      BusStop(
        id: 'B-XLHN1',
        name: 'Trạm Xa lộ Hà Nội – Thảo Điền',
        lat: 10.8020,
        lng: 106.7345,
        walkMinutes: 2,
        routes: ['10', '52', '93'],
      ),
    ],
    'AP': [
      BusStop(
        id: 'B-AP',
        name: 'Trạm An Phú',
        lat: 10.8028,
        lng: 106.7432,
        walkMinutes: 2,
        routes: ['52', '93', '99'],
      ),
    ],
    'RC': [
      BusStop(
        id: 'B-RC',
        name: 'Trạm cầu Rạch Chiếc',
        lat: 10.8090,
        lng: 106.7560,
        walkMinutes: 3,
        routes: ['10', '52'],
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
    'DHQG': [
      BusStop(
        id: 'B-DHQG',
        name: 'Trạm Đại học Quốc gia',
        lat: 10.8700,
        lng: 106.8020,
        walkMinutes: 4,
        routes: ['08', '19', '33', '50'],
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
