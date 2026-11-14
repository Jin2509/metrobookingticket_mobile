import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/models/line_badge_data.dart';
import 'package:metro_mobile/design_system/models/station_option.dart';
import 'package:metro_mobile/design_system/molecules/station_picker/station_filter.dart';

const _l1 = LineBadgeData(
  id: 'L1',
  code: 'Tuyến 1',
  name: 'Bến Thành – Suối Tiên',
  color: Color(0xFFE2231A),
);
const _l2 = LineBadgeData(
  id: 'L2',
  code: 'Tuyến 2',
  name: 'Bến Thành – Tham Lương',
  color: Color(0xFFF7A800),
  planned: true,
);

void main() {
  const stations = [
    StationOption(id: 'BT', name: 'Bến Thành', lines: [_l1, _l2]),
    StationOption(id: 'BS', name: 'Ba Son', lines: [_l1]),
    StationOption(id: 'TD', name: 'Thủ Đức', lines: [_l1]),
    StationOption(id: 'ST', name: 'Suối Tiên', lines: [_l1]),
    StationOption(id: 'TDN', name: 'Tao Đàn', lines: [_l2], active: false),
  ];

  test('không có từ khóa: nhóm theo tuyến, ga chuyển tuyến ở cả 2 nhóm', () {
    final groups = groupStations(stations, '');
    expect(groups.map((g) => g.line.id), ['L1', 'L2']);
    expect(groups[0].stations.map((s) => s.id), ['BT', 'BS', 'TD', 'ST']);
    expect(groups[1].stations.map((s) => s.id), ['BT', 'TDN']);
  });

  test('tìm không dấu', () {
    final groups = groupStations(stations, 'suoi tien');
    expect(groups, hasLength(1));
    expect(groups.single.stations.single.name, 'Suối Tiên');
  });

  test('không có kết quả trả danh sách rỗng', () {
    expect(groupStations(stations, 'tham luong'), isEmpty);
  });
}
