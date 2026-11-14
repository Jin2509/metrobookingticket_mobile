import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/core/network/sse_client.dart';
import 'package:metro_mobile/features/notifications/data/sources/notification_dtos.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';
import 'package:metro_mobile/features/notifications/domain/repositories/notification_repository.dart';

/// Hộp thư `/api/me/notifications` (đẩy realtime qua SSE `/stream`), tin
/// tức = thông báo vận hành đã duyệt `/api/v1/announcements`.
class NotificationRemoteSource implements NotificationRepository {
  const NotificationRemoteSource(this._dio);
  final Dio _dio;

  Future<T> _call<T>(
    String method,
    String path, {
    Object? body,
    Map<String, Object?>? query,
  }) async {
    try {
      final res = await _dio.request<T>(
        path,
        data: body,
        queryParameters: query,
        options: Options(method: method),
      );
      return res.data as T;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<List<AppNotification>> getNotifications() async {
    final page = await _call<Json>(
      'GET',
      '/api/me/notifications',
      query: {'size': 50},
    );
    return [
      for (final j in page['content']! as List)
        NotificationDtos.notification(j as Json),
    ];
  }

  @override
  Future<void> markRead(String id) =>
      _call<void>('PATCH', '/api/me/notifications/$id/read');

  @override
  Future<void> markAllRead() =>
      _call<void>('POST', '/api/me/notifications/read-all');

  @override
  Stream<AppNotification> watchIncoming() =>
      sseEvents(_dio, '/api/me/notifications/stream')
          .where((e) => e.event == 'notification')
          .map(
            (e) => NotificationDtos.notification(jsonDecode(e.data) as Json),
          );

  @override
  Future<List<NewsItem>> getNews() async {
    final list = await _call<List<dynamic>>(
      'GET',
      '/api/v1/announcements',
      query: {'status': 'APPROVED'},
    );
    final now = DateTime.now();
    final items = [
      for (final j in list.cast<Json>())
        if (j['endsAt'] == null ||
            DateTime.parse(j['endsAt']! as String).isAfter(now))
          NotificationDtos.news(j),
    ]..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return items;
  }

  @override
  Future<NotificationPrefs> getPrefs() async => NotificationDtos.prefs(
    await _call<Json>('GET', '/api/me/notification-preferences'),
  );

  @override
  Future<NotificationPrefs> updatePrefs(NotificationPrefs p) async =>
      NotificationDtos.prefs(
        await _call<Json>(
          'PUT',
          '/api/me/notification-preferences',
          body: NotificationDtos.prefsJson(p),
        ),
      );

  @override
  Future<void> registerDeviceToken(String token) => _call<void>(
    'POST',
    '/api/me/devices',
    body: {
      'token': token,
      'platform': defaultTargetPlatform == TargetPlatform.iOS
          ? 'IOS'
          : 'ANDROID',
    },
  );
}
