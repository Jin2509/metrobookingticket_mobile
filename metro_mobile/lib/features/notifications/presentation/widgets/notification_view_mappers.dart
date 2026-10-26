import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `notification_type` → icon/màu của `NotificationTile`.
NotificationKind notificationKindOf(String code) => switch (code) {
  'PAYMENT' => NotificationKind.payment,
  'TICKET_EXPIRY' => NotificationKind.ticketExpiry,
  'SUGGESTION' => NotificationKind.suggestion,
  'OPERATION' => NotificationKind.operation,
  'PROMOTION' => NotificationKind.promotion,
  _ => NotificationKind.news,
};

/// `10:02` (hôm nay), `Hôm qua`, `20/10`.
String notificationTime(AppLocalizations l, DateTime t, {DateTime? now}) {
  final today = toVnTime(now ?? DateTime.now());
  final day = toVnTime(t);
  final diff = DateTime(
    today.year,
    today.month,
    today.day,
  ).difference(DateTime(day.year, day.month, day.day)).inDays;
  if (diff == 0) return timeOnly(t);
  if (diff == 1) return l.yesterday;
  return dateOnly(t).substring(0, 5);
}
