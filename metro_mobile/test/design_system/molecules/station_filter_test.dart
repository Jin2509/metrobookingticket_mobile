import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/gallery/gallery_sample_data.dart';
import 'package:metro_mobile/design_system/molecules/station_picker/station_filter.dart';

void main() {
  const stations = GallerySample.stations;

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
