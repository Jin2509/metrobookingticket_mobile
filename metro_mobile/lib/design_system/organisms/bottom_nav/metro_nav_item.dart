import 'package:flutter/widgets.dart';

/// Cấu hình một tab, giống `nav.config.ts` trên web.
@immutable
class MetroNavItem {
  const MetroNavItem({
    required this.icon,
    required this.label,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;
  final int badgeCount;

  MetroNavItem withBadge(int count) =>
      MetroNavItem(icon: icon, label: label, badgeCount: count);
}
