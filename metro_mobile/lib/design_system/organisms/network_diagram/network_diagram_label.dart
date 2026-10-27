import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/network_diagram/network_layout_types.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';

/// Nút bấm của một ga: phủ cả nút tròn và nhãn, cao 48dp.
class DiagramStationLabel extends StatelessWidget {
  const DiagramStationLabel({
    required this.node,
    required this.width,
    required this.onTap,
    super.key,
  });

  final DiagramNode node;
  final double width;
  final VoidCallback onTap;

  /// Vùng chạm phủ cả nút ga; chữ cách tâm nút [_gap].
  static const _gap = 16.0;
  static const _h = 48.0;

  @override
  Widget build(BuildContext context) {
    final n = node;
    final style =
        (n.terminal || n.interchange
                ? context.text.labelLarge
                : context.text.bodySmall)
            ?.copyWith(
              color: n.planned ? context.metro.mutedForeground : null,
              height: 1.15,
            );
    final text = Text(
      n.station.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: switch (n.side) {
        DiagramLabelSide.left => TextAlign.right,
        DiagramLabelSide.right => TextAlign.left,
        _ => TextAlign.center,
      },
      style: style,
    );
    final button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: switch (n.side) {
        DiagramLabelSide.right => Padding(
          padding: const EdgeInsets.only(left: _gap * 2),
          child: Align(alignment: Alignment.centerLeft, child: text),
        ),
        DiagramLabelSide.left => Padding(
          padding: const EdgeInsets.only(right: _gap * 2),
          child: Align(alignment: Alignment.centerRight, child: text),
        ),
        DiagramLabelSide.below => Align(
          alignment: Alignment.bottomCenter,
          child: text,
        ),
        DiagramLabelSide.above => Align(
          alignment: Alignment.topCenter,
          child: text,
        ),
      },
    );
    final p = n.pos;
    return switch (n.side) {
      DiagramLabelSide.right => Positioned(
        left: p.dx - _gap,
        top: p.dy - _h / 2,
        width: width + _gap * 2,
        height: _h,
        child: button,
      ),
      DiagramLabelSide.left => Positioned(
        left: p.dx + _gap - width - _gap * 2,
        top: p.dy - _h / 2,
        width: width + _gap * 2,
        height: _h,
        child: button,
      ),
      DiagramLabelSide.below => Positioned(
        left: p.dx - width / 2,
        top: p.dy - 14,
        width: width,
        height: _h,
        child: button,
      ),
      DiagramLabelSide.above => Positioned(
        left: p.dx - width / 2,
        top: p.dy + 14 - _h,
        width: width,
        height: _h,
        child: button,
      ),
    };
  }
}
