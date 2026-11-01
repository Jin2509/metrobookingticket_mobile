import 'package:dio/dio.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/network/auth_interceptor.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';

/// Tạo Dio dùng chung, gắn `AuthInterceptor`.
Dio createDio({
  required SecureStore store,
  required Future<void> Function() onSessionExpired,
  required Future<void> Function() onTokensRefreshed,
  String baseUrl = Env.baseUrl,
  HttpClientAdapter? adapter,
}) {
  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
      ),
    );
    if (adapter != null) dio.httpClientAdapter = adapter;
    return dio;
  }

  return create()
    ..interceptors.add(
      AuthInterceptor(
        store: store,
        refreshDio: create(),
        onSessionExpired: onSessionExpired,
        onTokensRefreshed: onTokensRefreshed,
      ),
    );
}
