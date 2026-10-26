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
