import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/models/diagram_stop.dart';
import 'package:metro_mobile/design_system/organisms/line_diagram/line_diagram_painter.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Một dòng: cột vẽ tuyến + tên ga, phụ đề, nhãn phải.
class LineDiagramStationRow extends StatelessWidget {
  const LineDiagramStationRow({
    required this.stop,
    required this.previous,
    required this.isLast,
    this.onTap,
    super.key,
  });

  final DiagramStop stop;

  /// Dòng phía trên (màu và kiểu nét của đoạn trên).
  final DiagramStop? previous;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final collapsed = stop.isCollapsed;
    final painter = LineDiagramPainter(
      above: previous?.color,
      below: isLast ? null : stop.color,
      node: collapsed ? null : stop.color,
      background: m.card,
      interchange: stop.interchange,
      filled: stop.highlighted,
      dashedAbove: previous?.dashed ?? false,
      dashedBelow: stop.dashed,
    );
    return InkWell(
      onTap: collapsed ? null : onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: collapsed ? 32 : 52),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: 40, child: CustomPaint(painter: painter)),
              MetroSpacing.gapXs,
              Expanded(
                child: collapsed
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          context.l10n.stationCount(stop.collapsedCount!),
                          style: context.text.labelSmall,
                        ),
                      )
                    : _Texts(stop: stop),
              ),
              if (stop.trailing != null)
                Padding(
                  padding: const EdgeInsets.only(right: MetroSpacing.md),
                  child: Center(
                    child: Text(stop.trailing!, style: context.text.labelSmall),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({required this.stop});
  final DiagramStop stop;

  @override
  Widget build(BuildContext context) {
    final weight = stop.highlighted ? FontWeight.w700 : FontWeight.w500;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stop.name,
          style: context.text.bodyLarge?.copyWith(fontWeight: weight),
        ),
        if (stop.subtitle != null)
          Text(stop.subtitle!, style: context.text.labelSmall),
        if (stop.trainApproaching)
          Row(
            children: [
              Icon(
                LucideIcons.trainFront,
                size: 13,
                color: context.metro.accent,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  context.l10n.trainApproaching,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelSmall?.copyWith(
                    color: context.metro.accent,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
