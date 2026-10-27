import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// `① Chọn vé ── ② Xác nhận ── ③ Thanh toán`: cho biết đang ở bước nào
/// của luồng mua vé. Bước đã qua hiện dấu ✓.
class BookingStepper extends StatelessWidget {
  const BookingStepper({required this.steps, required this.current, super.key});

  final List<String> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Semantics(
      label: '${current + 1}/${steps.length}: ${steps[current]}',
      excludeSemantics: true,
      child: Row(
        children: [
          for (final (i, label) in steps.indexed) ...[
            if (i > 0)
              Expanded(
                child: Divider(
                  indent: MetroSpacing.xxs,
                  endIndent: MetroSpacing.xxs,
                  thickness: 2,
                  color: i <= current ? primary : m.border,
                ),
              ),
            CircleAvatar(
              radius: 11,
              backgroundColor: i <= current ? primary : m.muted,
              child: i < current
                  ? Icon(LucideIcons.check, size: 14, color: onPrimary)
                  : Text(
                      '${i + 1}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: i == current ? onPrimary : m.mutedForeground,
                      ),
                    ),
            ),
            MetroSpacing.gapXxs,
            Flexible(
              flex: 3,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: i == current ? FontWeight.w700 : null,
                  color: i == current ? null : m.mutedForeground,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
