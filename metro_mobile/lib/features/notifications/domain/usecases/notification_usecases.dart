import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';
import 'package:metro_mobile/features/notifications/domain/repositories/notification_repository.dart';

/// UC13-01/02 hộp thông báo: tải, đánh dấu đã đọc, nhận realtime.
class ManageInbox {
  const ManageInbox(this._repo);
  final NotificationRepository _repo;

  Future<List<AppNotification>> load() async {
    final list = await _repo.getNotifications();
    return [...list]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> markRead(String id) => _repo.markRead(id);
  Future<void> markAllRead() => _repo.markAllRead();
  Stream<AppNotification> incoming() => _repo.watchIncoming();
}

/// Tin tức & vận hành (P61).
class GetNews {
  const GetNews(this._repo);
  final NotificationRepository _repo;

  Future<List<NewsItem>> call() => _repo.getNews();
}

/// UC13-03. A1: không cho tắt loại bắt buộc.
class UpdateNotificationPrefs {
  const UpdateNotificationPrefs(this._repo);
  final NotificationRepository _repo;

  static const mandatoryMessage =
      'Thông báo vận hành và kết quả thanh toán là bắt buộc';

  Future<NotificationPrefs> load() => _repo.getPrefs();

  Future<NotificationPrefs> call(NotificationPrefs p) {
    if (!p.operation || !p.payment) {
      throw const ValidationFailure(mandatoryMessage);
    }
    return _repo.updatePrefs(p);
  }
}
