import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';

typedef Json = Map<String, Object?>;

/// JSON ↔ entity cho `/api/notifications`, `/api/news`, tùy chọn TB.
abstract final class NotificationDtos {
  static AppNotification notification(Json j) => AppNotification(
    id: '${j['id']}',
    kind: j['kind'] as String? ?? j['type'] as String? ?? 'NEWS',
    title: j['title'] as String? ?? '',
    body: j['body'] as String?,
    createdAt: DateTime.parse(j['createdAt']! as String),
    read: j['read'] as bool? ?? false,
    link: j['link'] as String?,
  );

  static NewsItem news(Json j) => NewsItem(
    id: '${j['id']}',
    title: j['title'] as String? ?? '',
    summary: j['summary'] as String? ?? '',
    body: j['body'] as String? ?? '',
    publishedAt: DateTime.parse(j['publishedAt']! as String),
    operational: j['category'] == 'OPERATION',
    imageUrl: j['imageUrl'] as String?,
  );

  static NotificationPrefs prefs(Json j) => NotificationPrefs(
    push: j['push'] as bool? ?? true,
    email: j['email'] as bool? ?? true,
    promotion: j['promotion'] as bool? ?? true,
    smart: j['smart'] as bool? ?? false,
  );

  static Json prefsJson(NotificationPrefs p) => {
    'push': p.push,
    'email': p.email,
    'promotion': p.promotion,
    'smart': p.smart,
    'operation': p.operation,
    'payment': p.payment,
  };
}
