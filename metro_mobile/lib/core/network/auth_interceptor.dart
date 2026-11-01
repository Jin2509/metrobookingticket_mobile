import 'package:dio/dio.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';

/// Gắn Bearer và là NƠI DUY NHẤT gọi `/api/auth/refresh`.
///
/// Refresh token chỉ dùng được một lần, gửi lại token đã dùng sẽ bị thu hồi cả
/// phiên. `QueuedInterceptor` xếp hàng các 401 nên tại một thời điểm chỉ có một
/// request refresh; 401 xếp sau thấy token đã đổi thì phát lại luôn.
///
/// - Refresh 401/403: xóa token, gọi `onSessionExpired`.
/// - Lỗi mạng/5xx: giữ token, trả lỗi đó cho nơi gọi (chưa đăng xuất).
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required SecureStore store,
    required Dio refreshDio,
    required Future<void> Function() onSessionExpired,
    required Future<void> Function() onTokensRefreshed,
  }) : _store = store,
       _refreshDio = refreshDio,
       _onSessionExpired = onSessionExpired,
       _onTokensRefreshed = onTokensRefreshed;

  final SecureStore _store;

  /// Không gắn interceptor: phát lại request nên không lặp vòng 401.
  final Dio _refreshDio;
  final Future<void> Function() _onSessionExpired;
  final Future<void> Function() _onTokensRefreshed;

  static const _logoutPath = '/api/auth/logout';

  static bool _isAuthCall(RequestOptions req) =>
      req.path.startsWith('/api/auth/');

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // API auth không cần token; logout gửi kèm để thu hồi access token ngay.
    if (!_isAuthCall(options) || options.path == _logoutPath) {
      final token = await _store.accessToken;
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final req = err.requestOptions;
    if (err.response?.statusCode != 401 || _isAuthCall(req)) {
      return handler.next(err);
    }
    final current = await _store.accessToken;
    if (current == null || req.headers['Authorization'] == 'Bearer $current') {
      final refreshError = await _refresh();
      if (refreshError != null) return handler.next(refreshError);
    }
    final token = await _store.accessToken;
    if (token == null) return handler.next(err);
    try {
      req.headers['Authorization'] = 'Bearer $token';
      handler.resolve(await _refreshDio.fetch<dynamic>(req));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// `null` khi đã có token mới. Phiên hết hạn thì store đã bị xóa.
  Future<DioException?> _refresh() async {
    final refresh = await _store.refreshToken;
    if (refresh == null) {
      await _expire();
      return null;
    }
    try {
      final res = await _refreshDio.post<Map<String, dynamic>>(
        '/api/auth/refresh',
        data: {'refreshToken': refresh},
      );
      // Đăng xuất trong lúc chờ: không khôi phục lại token vừa nhận.
      if (await _store.refreshToken != refresh) return null;
      final data = res.data!;
      await _store.saveTokens(
        access: data['accessToken'] as String,
        refresh: data['refreshToken'] as String,
      );
      await _onTokensRefreshed();
      return null;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status != 401 && status != 403) return e;
      await _expire();
      return null;
    }
  }

  Future<void> _expire() async {
    await _store.clear();
    await _onSessionExpired();
  }
}
