import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';

abstract interface class NotificationRepository {
  Future<List<AppNotification>> getNotifications();
  Future<void> markRead(String id);
  Future<void> markAllRead();

  /// WS `/user/queue/notifications`.
  Stream<AppNotification> watchIncoming();

  Future<List<NewsItem>> getNews();
  Future<NotificationPrefs> getPrefs();

  /// 400 nếu cố tắt thông báo bắt buộc.
  Future<NotificationPrefs> updatePrefs(NotificationPrefs prefs);

  /// Đăng ký `device_token` cho push (UC13-01).
  Future<void> registerDeviceToken(String token);
}
