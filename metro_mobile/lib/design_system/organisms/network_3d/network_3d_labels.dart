import 'package:flutter/painting.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_camera.dart';
import 'package:metro_mobile/design_system/organisms/network_3d/network_3d_scene.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';

const _white = Color(0xFFFFFFFF);

/// Vẽ nhãn lần lượt theo thứ tự ưu tiên, bỏ nhãn đè lên nhãn đã vẽ.
void paintLabels(
  Canvas canvas,
  List<({String text, Offset at, bool strong})> labels,
) {
  final taken = <Rect>[];
  for (final l in labels) {
    final painter = TextPainter(
      text: TextSpan(
        text: l.text,
        style: MetroTypography.label.copyWith(
          color: _white,
          fontSize: l.strong ? 12 : 11,
          fontWeight: l.strong ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    final origin = l.at + Offset(-painter.width / 2, -painter.height - 12);
    final rect = (origin & painter.size).inflate(5);
    if (taken.any(rect.overlaps)) continue;
    taken.add(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      Paint()..color = const Color(0xB3081320),
    );
    painter.paint(canvas, origin);
  }
}

/// Bán kính ga theo vai trò, đã tính phối cảnh.
double stationRadius(SceneNode node, Projected p, {required bool selected}) {
  final base = selected
      ? 8.0
      : node.interchange
      ? 7.0
      : node.terminus
      ? 6.0
      : 4.6;
  return base * p.scale;
}
