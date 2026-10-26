import 'package:dio/dio.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/network/auth_interceptor.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';

/// Tạo Dio dùng chung, gắn `AuthInterceptor`.
Dio createDio({
  required SecureStore store,
  required Future<void> Function() onSessionExpired,
  String baseUrl = Env.baseUrl,
}) {
  BaseOptions options() => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    contentType: Headers.jsonContentType,
  );
  return Dio(options())
    ..interceptors.add(
      AuthInterceptor(
        store: store,
        refreshDio: Dio(options()),
        onSessionExpired: onSessionExpired,
      ),
    );
}
