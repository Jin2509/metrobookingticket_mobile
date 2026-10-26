import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/notifications/data/sources/notification_dtos.dart';
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
    final now = _ledger.clock();
    return [
      NewsItem(
        id: 'N3',
        title: 'Bảo trì thang cuốn ga Ba Son',
        summary: 'Thang cuốn cửa 2 tạm dừng 07:00–11:00 ngày mai.',
        body:
            'Hành khách vui lòng sử dụng thang máy hoặc cửa 1. '
            'Nhân viên ga hỗ trợ người cao tuổi và người khuyết tật.',
        publishedAt: now.subtract(const Duration(hours: 2)),
        operational: true,
      ),
      NewsItem(
        id: 'N2',
        title: 'Tăng chuyến giờ cao điểm từ 01/11',
        summary: 'Giãn cách 6 phút/chuyến lúc 07:00–09:00 và 17:00–19:00.',
        body: 'Tuyến 1 bổ sung 12 chuyến mỗi ngày trong giờ cao điểm.',
        publishedAt: now.subtract(const Duration(days: 2)),
      ),
      NewsItem(
        id: 'N1',
        title: 'Mở bán vé tháng HSSV trên ứng dụng',
        summary: 'Giảm 50% so với vé tháng thường.',
        body: 'Học sinh, sinh viên xác thực thẻ để mua vé tháng HSSV.',
        publishedAt: now.subtract(const Duration(days: 6)),
      ),
    ];
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
