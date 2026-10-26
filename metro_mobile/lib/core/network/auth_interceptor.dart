import 'package:dio/dio.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';

/// Gắn Bearer. Gặp 401 thì refresh token đúng 1 lần rồi phát lại request;
/// refresh thất bại thì gọi `onSessionExpired` (logout).
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required SecureStore store,
    required Dio refreshDio,
    required Future<void> Function() onSessionExpired,
  }) : _store = store,
       _refreshDio = refreshDio,
       _onSessionExpired = onSessionExpired;

  final SecureStore _store;
  final Dio _refreshDio;
  final Future<void> Function() _onSessionExpired;

  static const _retried = 'auth_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _store.accessToken;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final req = err.requestOptions;
    final isAuthCall = req.path.startsWith('/api/auth/');
    if (err.response?.statusCode != 401 ||
        req.extra[_retried] == true ||
        isAuthCall) {
      return handler.next(err);
    }
    final refreshed = await _refresh();
    if (!refreshed) {
      await _onSessionExpired();
      return handler.next(err);
    }
    try {
      req.extra[_retried] = true;
      req.headers['Authorization'] = 'Bearer ${await _store.accessToken}';
      handler.resolve(await _refreshDio.fetch<dynamic>(req));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<bool> _refresh() async {
    final refresh = await _store.refreshToken;
    if (refresh == null) return false;
    try {
      final res = await _refreshDio.post<Map<String, dynamic>>(
        '/api/auth/refresh',
        data: {'refreshToken': refresh},
      );
      final data = res.data!;
      await _store.saveTokens(
        access: data['accessToken'] as String,
        refresh: data['refreshToken'] as String? ?? refresh,
      );
      return true;
    } on DioException {
      return false;
    }
  }
}
