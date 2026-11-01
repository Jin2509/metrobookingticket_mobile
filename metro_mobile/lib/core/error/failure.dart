/// Lỗi tầng domain, map từ `ApiException` (mục 10.1).
sealed class Failure implements Exception {
  const Failure(this.message);

  /// Thông điệp tiếng Việt hiển thị cho người dùng.
  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Không có kết nối mạng']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Sai thông tin đăng nhập']);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'Bạn không có quyền thực hiện']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Không tìm thấy dữ liệu']);
}

class ConflictFailure extends Failure {
  const ConflictFailure([super.message = 'Dữ liệu đã thay đổi']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Dữ liệu không hợp lệ']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Hệ thống đang bận, thử lại sau']);
}

/// 403 do tài khoản bị khóa (A1: banner đỏ).
class AccountLockedFailure extends Failure {
  const AccountLockedFailure([super.message = 'Tài khoản đã bị khóa']);
}

/// 403 khi đăng nhập bằng email chưa xác thực: chuyển sang màn OTP.
class EmailNotVerifiedFailure extends Failure {
  const EmailNotVerifiedFailure([super.message = 'Email chưa được xác thực']);
}

/// 202 khi đăng nhập: đúng mật khẩu, còn phải nhập mã gửi qua email.
class TwoFactorRequiredFailure extends Failure {
  const TwoFactorRequiredFailure(this.ticket, [this.expiresIn])
    : super('Cần xác nhận 2 lớp');

  final String ticket;

  /// Thời gian còn lại của mã, có thể không có.
  final Duration? expiresIn;
}

/// 429. [retryAfter] lấy từ header `Retry-After`, có thể không có.
class RateLimitedFailure extends Failure {
  const RateLimitedFailure([super.message = defaultMessage, this.retryAfter]);

  static const defaultMessage = 'Bạn thao tác quá nhanh, vui lòng thử lại sau';

  final Duration? retryAfter;
}
