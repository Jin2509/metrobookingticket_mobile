import 'package:flutter/foundation.dart';
import 'package:metro_mobile/design_system/models/line_badge_data.dart';

/// Một ga trong `StationPickerSheet` và `StationTile`.
@immutable
class StationOption {
  const StationOption({
    required this.id,
    required this.name,
    required this.lines,
    this.active = true,
  });

  final String id;
  final String name;
  final List<LineBadgeData> lines;

  /// `false` khi ga ngừng hoạt động (UC5-03 A2).
  final bool active;

  bool get isInterchange => lines.length > 1;
}
