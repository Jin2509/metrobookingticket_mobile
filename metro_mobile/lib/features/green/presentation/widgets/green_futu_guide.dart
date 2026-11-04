import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Futu hướng dẫn trong cảnh Trái Đất. Chạm để xem câu tiếp theo.
class GreenFutuGuide extends StatefulWidget {
  const GreenFutuGuide({required this.summary, super.key});

  final GreenSummary summary;

  @override
  State<GreenFutuGuide> createState() => _GreenFutuGuideState();
}

class _GreenFutuGuideState extends State<GreenFutuGuide> {
  int _index = 0;

  void _next() => setState(() => _index++);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lines = [
      greenFutuLine(l, widget.summary),
      l.greenFutuTipCount,
      l.greenFutuTipSpin,
    ];
    final text = lines[_index % lines.length];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        MetroMascot(
          size: 64,
          mood: widget.summary.trips > 0 ? MascotMood.happy : MascotMood.normal,
          semanticLabel: l.mascotLabel,
          onTap: _next,
        ),
        MetroSpacing.gapXs,
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onTap: _next,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: MetroColors.primaryForeground.withValues(alpha: .14),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(MetroRadius.lg),
                  topRight: Radius.circular(MetroRadius.lg),
                  bottomRight: Radius.circular(MetroRadius.lg),
                  bottomLeft: Radius.circular(MetroSpacing.xxs),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: MetroSpacing.sm,
                  vertical: MetroSpacing.xs,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    text,
                    key: ValueKey(text),
                    style: context.text.bodyMedium?.copyWith(
                      color: MetroColors.primaryForeground,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
