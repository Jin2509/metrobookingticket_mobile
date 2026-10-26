import 'package:dio/dio.dart';
import 'package:metro_mobile/core/error/failure.dart';

/// Map lỗi Dio/HTTP sang `Failure` có thông điệp tiếng Việt (mục 10.1).
///
/// Ưu tiên `message` backend trả về; không có thì dùng thông điệp mặc định.
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
  final msg = data is Map ? data['message'] as String? : null;
  return switch (response?.statusCode) {
    400 => msg == null ? const ValidationFailure() : ValidationFailure(msg),
    401 => msg == null ? const UnauthorizedFailure() : UnauthorizedFailure(msg),
    403 when data is Map && data['code'] == 'ACCOUNT_LOCKED' =>
      const AccountLockedFailure(),
    403 => msg == null ? const ForbiddenFailure() : ForbiddenFailure(msg),
    404 => msg == null ? const NotFoundFailure() : NotFoundFailure(msg),
    409 => msg == null ? const ConflictFailure() : ConflictFailure(msg),
    null => const NetworkFailure(),
    _ => const ServerFailure(),
  };
}
