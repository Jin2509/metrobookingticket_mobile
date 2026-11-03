import 'package:flutter/widgets.dart';
import 'package:metro_mobile/design_system/organisms/vietnam_map/vietnam_map_painter.dart';

/// Bản đồ Việt Nam chìm làm nền, luôn có quần đảo Hoàng Sa và Trường Sa.
class VietnamMap extends StatelessWidget {
  const VietnamMap({
    required this.color,
    required this.highlight,
    required this.semanticLabel,
    required this.hoangSaLabel,
    required this.truongSaLabel,
    this.markerLabel,
    super.key,
  });

  final Color color;

  /// Màu điểm đánh dấu TP.HCM.
  final Color highlight;
  final String semanticLabel;
  final String hoangSaLabel;
  final String truongSaLabel;
  final String? markerLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: semanticLabel,
      child: AspectRatio(
        aspectRatio: VietnamMapPainter.aspectRatio,
        child: CustomPaint(
          painter: VietnamMapPainter(
            color: color,
            highlight: highlight,
            hoangSaLabel: hoangSaLabel,
            truongSaLabel: truongSaLabel,
            markerLabel: markerLabel,
          ),
        ),
      ),
    );
  }
}
