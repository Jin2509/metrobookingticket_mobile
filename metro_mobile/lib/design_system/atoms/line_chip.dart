import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/models/line_badge_data.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';

/// Chấm màu + mã tuyến. Có `onTap` thì dùng làm chip lọc (P23).
class LineChip extends StatelessWidget {
  const LineChip({
    required this.line,
    this.selected = false,
    this.onTap,
    super.key,
  });

  final LineBadgeData line;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final interactive = onTap != null;
    final bg = selected ? line.color.withValues(alpha: .15) : m.card;
    final border = selected ? line.color : m.border;
    return Semantics(
      button: interactive,
      selected: selected,
      label: line.code,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: MetroRadius.brPill,
          side: BorderSide(color: border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            // Chip lọc bấm được: vùng chạm tối thiểu 48dp.
            constraints: BoxConstraints(
              minHeight: interactive ? MetroSpacing.minTouch : 0,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: interactive ? 12 : 8,
                vertical: interactive ? 8 : 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: line.planned ? null : line.color,
                      shape: BoxShape.circle,
                      border: Border.all(color: line.color, width: 2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    line.code,
                    style: MetroTypography.label.copyWith(
                      color: context.colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
