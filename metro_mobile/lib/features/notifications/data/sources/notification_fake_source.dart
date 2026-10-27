import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/notifications/data/sources/notification_dtos.dart';
import 'package:metro_mobile/features/notifications/data/sources/notification_fake_news.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';
import 'package:metro_mobile/features/notifications/domain/repositories/notification_repository.dart';

/// Hộp thư demo trên `DemoLedger`; thanh toán xong sẽ đẩy thông báo mới.
class NotificationFakeSource implements NotificationRepository {
  NotificationFakeSource(
    this._ledger, {
    this.latency = const Duration(milliseconds: 300),
  });

  final DemoLedger _ledger;
  final Duration latency;
  NotificationPrefs _prefs = const NotificationPrefs();
  final tokens = <String>[];

  Future<void> _wait() => Future<void>.delayed(latency);

  @override
  Future<List<AppNotification>> getNotifications() async {
    await _wait();
    return _ledger.notifications.map(NotificationDtos.notification).toList();
  }

  @override
  Future<void> markRead(String id) async {
    for (final n in _ledger.notifications) {
      if (n['id'] == id) n['read'] = true;
    }
  }

  @override
  Future<void> markAllRead() async {
    for (final n in _ledger.notifications) {
      n['read'] = true;
    }
  }

  @override
  Stream<AppNotification> watchIncoming() =>
      _ledger.notificationEvents.map(NotificationDtos.notification);

  @override
  Future<List<NewsItem>> getNews() async {
    await _wait();
    return NotificationFakeNews.items(_ledger.clock());
  }

  @override
  Future<NotificationPrefs> getPrefs() async {
    await _wait();
    return _prefs;
  }

  @override
  Future<NotificationPrefs> updatePrefs(NotificationPrefs p) async {
    await _wait();
    if (!p.operation || !p.payment) {
      throw const ValidationFailure('Không thể tắt thông báo bắt buộc');
    }
    return _prefs = p;
  }

  @override
  Future<void> registerDeviceToken(String token) async => tokens.add(token);
}
