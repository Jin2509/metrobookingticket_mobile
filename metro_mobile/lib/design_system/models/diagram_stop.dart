import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Một dòng trong `LineDiagram`.
@immutable
class DiagramStop {
  const DiagramStop({
    required this.id,
    required this.name,
    required this.color,
    this.subtitle,
    this.trailing,
    this.interchange = false,
    this.highlighted = false,
    this.dashed = false,
    this.trainApproaching = false,
    this.collapsedCount,
  });

  /// Dòng rút gọn `│ 10 ga` giữa hai ga (kết quả lộ trình).
  const DiagramStop.collapsed({
    required int count,
    required this.color,
    this.dashed = false,
  }) : id = '',
       name = '',
       subtitle = null,
       trailing = null,
       interchange = false,
       highlighted = false,
       trainApproaching = false,
       collapsedCount = count;

  final String id;
  final String name;

  /// Màu nút và đoạn tuyến phía dưới nút.
  final Color color;

  /// VD `Chuyển Tuyến 2` hoặc `Đổi sang Tuyến 1`.
  final String? subtitle;

  /// VD `Ngầm`, `Trên cao`.
  final String? trailing;
  final bool interchange;

  /// Ga đi/đến hoặc ga hiện tại: nút tô đặc.
  final bool highlighted;

  /// Tuyến quy hoạch: đoạn dưới vẽ nét đứt.
  final bool dashed;

  /// Có tàu đang chạy tới ga này (realtime).
  final bool trainApproaching;
  final int? collapsedCount;

  bool get isCollapsed => collapsedCount != null;
}
