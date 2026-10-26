import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Dữ liệu hiển thị một tuyến. Feature map từ entity `MetroLine` sang.
@immutable
class LineBadgeData {
  const LineBadgeData({
    required this.id,
    required this.code,
    required this.name,
    required this.color,
    this.planned = false,
  });

  final String id;

  /// Nhãn ngắn, VD `Tuyến 1`.
  final String code;

  /// Tên đầy đủ, VD `Bến Thành – Suối Tiên`.
  final String name;
  final Color color;

  /// Tuyến quy hoạch (vẽ nét đứt).
  final bool planned;
}
