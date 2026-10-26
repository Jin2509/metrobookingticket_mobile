import 'package:metro_mobile/core/utils/vn_text.dart';
import 'package:metro_mobile/design_system/models/line_badge_data.dart';
import 'package:metro_mobile/design_system/models/station_option.dart';

typedef StationGroup = ({LineBadgeData line, List<StationOption> stations});

/// Lọc ga theo [query] (không dấu) rồi nhóm theo tuyến, giữ thứ tự đầu
/// vào. Ga chuyển tuyến xuất hiện ở mọi tuyến nó thuộc về.
List<StationGroup> groupStations(List<StationOption> stations, String query) {
  final groups = <String, StationGroup>{};
  for (final s in stations) {
    if (query.isNotEmpty && !vnContains(s.name, query)) continue;
    for (final line in s.lines) {
      groups
          .putIfAbsent(line.id, () => (line: line, stations: []))
          .stations
          .add(s);
    }
  }
  return groups.values.toList();
}
