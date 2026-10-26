import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Loại thông báo (`notification_type`) và icon tương ứng (P60).
enum NotificationKind {
  payment(LucideIcons.creditCard),
  ticketExpiry(LucideIcons.alarmClock),
  suggestion(LucideIcons.lightbulb),
  operation(LucideIcons.triangleAlert),
  promotion(LucideIcons.badgePercent),
  news(LucideIcons.megaphone);

  NotificationKind(this.icon);
  final IconData icon;
}
