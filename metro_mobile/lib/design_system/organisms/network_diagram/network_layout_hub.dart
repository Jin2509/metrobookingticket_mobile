import 'package:metro_mobile/design_system/models/line_badge_data.dart';
import 'package:metro_mobile/design_system/models/network_diagram_models.dart';

/// Ga làm tâm sơ đồ: ga thuộc nhiều tuyến nhất (hòa thì ga gặp trước;
/// không có ga chung thì lấy ga đầu tuyến đầu tiên). Kèm danh sách tuyến
/// đi qua từng ga. `null` nếu không có ga nào.
({DiagramStationData hub, Map<String, List<LineBadgeData>> linesOf})? findHub(
  List<NetworkDiagramLine> lines,
) {
  final linesOf = <String, List<LineBadgeData>>{};
  DiagramStationData? hub;
  for (final l in lines) {
    for (final s in l.stations) {
      final ls = (linesOf[s.id] ??= [])..add(l.line);
      if (hub == null || ls.length > linesOf[hub.id]!.length) hub = s;
    }
  }
  return hub == null ? null : (hub: hub, linesOf: linesOf);
}
