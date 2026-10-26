import 'package:flutter/foundation.dart';

/// Một chặng đi trên cùng một tuyến, gồm cả ga đầu và ga cuối chặng.
@immutable
class RouteLeg {
  const RouteLeg({required this.lineId, required this.stationIds});

  final String lineId;
  final List<String> stationIds;

  int get hops => stationIds.length - 1;
}

/// Kết quả tra cứu lộ trình (UC5-03).
@immutable
class RoutePlan {
  const RoutePlan({
    required this.legs,
    required this.minutes,
    required this.fare,
  });

  final List<RouteLeg> legs;
  final int minutes;
  final int fare;

  String get fromId => legs.first.stationIds.first;
  String get toId => legs.last.stationIds.last;
  int get transfers => legs.length - 1;

  /// Số ga đi qua (số chặng giữa hai ga liền kề).
  int get stationCount => legs.fold(0, (sum, l) => sum + l.hops);
}
