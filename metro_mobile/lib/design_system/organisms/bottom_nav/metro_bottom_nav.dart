import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/bottom_nav/metro_nav_button.dart';
import 'package:metro_mobile/design_system/organisms/bottom_nav/metro_nav_item.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';

export 'metro_nav_item.dart';

/// Bottom nav của từng shell (Passenger 5 tab, Staff 4 tab).
class MetroBottomNav extends StatelessWidget {
  const MetroBottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<MetroNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: m.card,
        border: Border(top: BorderSide(color: m.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: MetroNavButton(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
