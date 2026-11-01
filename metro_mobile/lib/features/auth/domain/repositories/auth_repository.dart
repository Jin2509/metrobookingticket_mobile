import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// Lỗi được ném dưới dạng `Failure` (core/error).
abstract interface class AuthRepository {
  /// Khôi phục phiên từ token đã lưu. `null` nếu chưa đăng nhập.
  Future<SessionUser?> restore();

  /// Lưu token rồi lấy thông tin và quyền từ `GET /api/me`.
  Future<SessionUser> login({
    required String email,
    required String password,
    required bool remember,
  });

  /// Bước 2 của đăng nhập khi [login] ném `TwoFactorRequiredFailure`.
  Future<SessionUser> verifyLoginCode({
    required String ticket,
    required String code,
    required bool remember,
  });

  Future<void> resendLoginCode(String ticket);

  /// Tạo tài khoản và gửi OTP tới email.
  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
  });

  /// Xác thực xong backend không tự đăng nhập.
  Future<void> verifyEmail({required String email, required String code});

  Future<void> resendCode(String email);

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  /// Luôn xóa token cục bộ, kể cả khi gọi API lỗi.
  Future<void> logout();

  /// Tải lại `GET /api/me`.
  Future<SessionUser> reloadUser();

  /// Đổi email chỉ có hiệu lực sau [verifyNewEmail].
  Future<SessionUser> updateProfile({
    required String name,
    String? newEmail,
    String? currentPassword,
  });

  /// Backend thu hồi mọi token nên token cục bộ bị xóa.
  Future<void> verifyNewEmail({required String email, required String code});

  /// Backend thu hồi mọi token nên token cục bộ bị xóa.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Phiên hiện tại giữ nguyên, lần đăng nhập sau mới có hiệu lực.
  Future<SessionUser> setTwoFactor({
    required bool enabled,
    required String currentPassword,
  });
}
