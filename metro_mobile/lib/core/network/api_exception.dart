import 'package:dio/dio.dart';
import 'package:metro_mobile/core/error/failure.dart';

/// Map lỗi Dio/HTTP sang `Failure` có thông điệp tiếng Việt.
///
/// Lỗi backend là `application/problem+json`: ưu tiên `detail`. Body có thể
/// rỗng (401/403 từ lớp bảo mật), khi đó dùng thông điệp mặc định.
Failure mapDioError(Object error) {
  if (error is Failure) return error;
  if (error is! DioException) return const ServerFailure();

  const offline = {
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.connectionError,
  };
  if (offline.contains(error.type)) return const NetworkFailure();

  final response = error.response;
  final data = response?.data;
  final detail = data is Map && data['detail'] is String
      ? data['detail'] as String
      : null;
  return switch (response?.statusCode) {
    400 =>
      detail == null ? const ValidationFailure() : ValidationFailure(detail),
    401 =>
      detail == null
          ? const UnauthorizedFailure()
          : UnauthorizedFailure(detail),
    403 => detail == null ? const ForbiddenFailure() : ForbiddenFailure(detail),
    404 => detail == null ? const NotFoundFailure() : NotFoundFailure(detail),
    409 => detail == null ? const ConflictFailure() : ConflictFailure(detail),
    429 => RateLimitedFailure(
      detail ?? RateLimitedFailure.defaultMessage,
      _retryAfter(response!),
    ),
    null => const NetworkFailure(),
    _ => const ServerFailure(),
  };
}

Duration? _retryAfter(Response<dynamic> response) {
  final seconds = int.tryParse(response.headers.value('retry-after') ?? '');
  return seconds == null ? null : Duration(seconds: seconds);
}
