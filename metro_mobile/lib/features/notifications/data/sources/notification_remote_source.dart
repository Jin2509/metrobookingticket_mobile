import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/core/network/stomp_client.dart';
import 'package:metro_mobile/features/notifications/data/sources/notification_dtos.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';
import 'package:metro_mobile/features/notifications/domain/repositories/notification_repository.dart';

/// `GET/PUT /api/notification-preferences` theo mục 9; hộp thư, tin tức
/// và device token là endpoint giả định, cần thống nhất với backend.
class NotificationRemoteSource implements NotificationRepository {
  const NotificationRemoteSource(this._dio, this._stomp);
  final Dio _dio;
  final MetroStompClient _stomp;

  Future<T> _call<T>(String method, String path, [Json? body]) async {
    try {
      final res = await _dio.request<T>(
        path,
        data: body,
        options: Options(method: method),
      );
      return res.data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<List<AppNotification>> getNotifications() async => [
    for (final j in await _call<List<dynamic>>('GET', '/api/notifications/my'))
      NotificationDtos.notification(j as Json),
  ];

  @override
  Future<void> markRead(String id) =>
      _call<void>('PATCH', '/api/notifications/$id/read');

  @override
  Future<void> markAllRead() =>
      _call<void>('POST', '/api/notifications/read-all');

  @override
  Stream<AppNotification> watchIncoming() => _stomp
      .subscribe('/user/queue/notifications')
      .where((j) => j is Json)
      .map((j) => NotificationDtos.notification(j! as Json));

  @override
  Future<List<NewsItem>> getNews() async => [
    for (final j in await _call<List<dynamic>>('GET', '/api/news'))
      NotificationDtos.news(j as Json),
  ];

  @override
  Future<NotificationPrefs> getPrefs() async => NotificationDtos.prefs(
    await _call<Json>('GET', '/api/notification-preferences'),
  );

  @override
  Future<NotificationPrefs> updatePrefs(NotificationPrefs p) async =>
      NotificationDtos.prefs(
        await _call<Json>(
          'PUT',
          '/api/notification-preferences',
          NotificationDtos.prefsJson(p),
        ),
      );

  @override
  Future<void> registerDeviceToken(String token) =>
      _call<void>('POST', '/api/device-tokens', {'token': token});
}
