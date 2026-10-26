import 'package:collection/collection.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';

/// Tìm lộ trình ít chuyển tuyến, rồi ít ga nhất (dùng cho Fake source;
/// bản thật do backend tính ở `/api/routes/search`).
///
/// Dijkstra trên nút (ga, tuyến): đi 1 ga tốn 1, đổi tuyến tốn
/// [transferCost]. Tuyến quy hoạch bị bỏ qua trừ khi [includePlanned].
class RoutePlanner {
  const RoutePlanner({this.transferCost = 3, this.includePlanned = false});

  final int transferCost;
  final bool includePlanned;

  RoutePlan? plan(NetworkCatalog catalog, String fromId, String toId) {
    final lines = catalog.lines.where((l) => includePlanned || !l.isPlanned);
    final next = <String, List<String>>{};
    void link(String a, String b) => (next[a] ??= []).add(b);
    for (final l in lines) {
      for (var i = 0; i + 1 < l.stationIds.length; i++) {
        final a = '${l.stationIds[i]}@${l.id}';
        final b = '${l.stationIds[i + 1]}@${l.id}';
        link(a, b);
        link(b, a);
      }
    }
    final nodesAt = <String, List<String>>{};
    for (final node in next.keys) {
      (nodesAt[node.split('@').first] ??= []).add(node);
    }

    final dist = <String, int>{};
    final prev = <String, String>{};
    final queue = PriorityQueue<(int, String)>((a, b) => a.$1 - b.$1);
    for (final n in nodesAt[fromId] ?? const <String>[]) {
      dist[n] = 0;
      queue.add((0, n));
    }
    String? end;
    while (queue.isNotEmpty) {
      final (d, node) = queue.removeFirst();
      if (d > (dist[node] ?? 1 << 30)) continue;
      final station = node.split('@').first;
      if (station == toId) {
        end = node;
        break;
      }
      final edges = [
        for (final n in next[node]!) (n, 1),
        for (final n in nodesAt[station]!)
          if (n != node) (n, transferCost),
      ];
      for (final (n, w) in edges) {
        if (d + w < (dist[n] ?? 1 << 30)) {
          dist[n] = d + w;
          prev[n] = node;
          queue.add((d + w, n));
        }
      }
    }
    if (end == null) return null;
    return _toPlan(end, prev);
  }

  RoutePlan _toPlan(String end, Map<String, String> prev) {
    final path = <String>[end];
    while (prev[path.last] != null) {
      path.add(prev[path.last]!);
    }
    final legs = <RouteLeg>[];
    for (final node in path.reversed) {
      final [station, line] = node.split('@');
      if (legs.isNotEmpty && legs.last.lineId == line) {
        legs.last.stationIds.add(station);
      } else {
        // Đổi tuyến: chặng mới bắt đầu tại chính ga chuyển tuyến.
        legs.add(RouteLeg(lineId: line, stationIds: [station]));
      }
    }
    final real = legs.where((l) => l.stationIds.length > 1).toList();
    final hops = real.fold(0, (s, l) => s + l.hops);
    final transfers = real.length - 1;
    return RoutePlan(
      legs: real,
      minutes: hops * 2 + transfers * 3 + 2,
      fare: fareFor(hops),
    );
  }

  /// Bậc giá demo theo số ga (bản thật lấy từ `ticket_price`).
  static int fareFor(int hops) => switch (hops) {
    <= 3 => 7000,
    <= 6 => 9000,
    <= 9 => 11000,
    <= 12 => 12000,
    _ => 15000,
  };
}
