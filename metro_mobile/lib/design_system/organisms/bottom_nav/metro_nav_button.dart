import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/bottom_nav/metro_nav_item.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';

/// Một nút tab: icon trong pill khi được chọn, nhãn, badge.
class MetroNavButton extends StatelessWidget {
  const MetroNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final MetroNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final color = selected ? context.colors.primary : m.mutedForeground;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        highlightShape: BoxShape.rectangle,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(
              isLabelVisible: item.badgeCount > 0,
              label: Text('${item.badgeCount}'),
              backgroundColor: m.destructive,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: selected ? color.withValues(alpha: .14) : null,
                  borderRadius: MetroRadius.brPill,
                ),
                child: Icon(item.icon, size: 22, color: color),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: MetroTypography.label.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
