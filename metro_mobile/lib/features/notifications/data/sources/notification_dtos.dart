import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';

typedef Json = Map<String, Object?>;

/// JSON ↔ entity cho `/api/me/notifications`, `/api/v1/announcements`,
/// `/api/me/notification-preferences`.
abstract final class NotificationDtos {
  /// `NotificationType` backend → loại thông báo của app.
  static String kind(String? type) => switch (type) {
    'TICKET' => 'TICKET_EXPIRY',
    'ANNOUNCEMENT' => 'OPERATION',
    'GREEN_JOURNEY' || 'STUDENT' || 'PARKING' => 'SUGGESTION',
    null => 'NEWS',
    _ => type,
  };

  static AppNotification notification(Json j) => AppNotification(
    id: '${j['id']}',
    kind: kind(j['type'] as String?),
    title: j['title'] as String? ?? '',
    body: j['body'] as String?,
    createdAt: DateTime.parse(j['createdAt']! as String),
    read: j['read'] as bool? ?? false,
    link: j['link'] as String?,
  );

  /// `AnnouncementResponse` đã duyệt. WARNING/CRITICAL là tin vận hành.
  static NewsItem news(Json j) {
    final content = j['content'] as String? ?? '';
    final firstPara = content.split(RegExp(r'\n\s*\n')).first.trim();
    return NewsItem(
      id: '${j['id']}',
      title: j['title'] as String? ?? '',
      summary: firstPara.length > 140
          ? '${firstPara.substring(0, 137)}...'
          : firstPara,
      body: content,
      publishedAt: DateTime.parse(
        (j['startsAt'] ?? j['approvedAt'] ?? j['createdAt'])! as String,
      ),
      operational: j['severity'] == 'WARNING' || j['severity'] == 'CRITICAL',
    );
  }

  static NotificationPrefs prefs(Json j) => NotificationPrefs(
    push: j['pushEnabled'] as bool? ?? true,
    email: j['emailEnabled'] as bool? ?? true,
    promotion: j['promotionEnabled'] as bool? ?? true,
    smart: j['reminderEnabled'] as bool? ?? false,
  );

  static Json prefsJson(NotificationPrefs p) => {
    'pushEnabled': p.push,
    'emailEnabled': p.email,
    'promotionEnabled': p.promotion,
    'reminderEnabled': p.smart,
  };
}
