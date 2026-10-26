import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// Lỗi được ném dưới dạng `Failure` (core/error).
abstract interface class AuthRepository {
  /// Khôi phục phiên từ refresh token đã lưu. `null` nếu chưa đăng nhập.
  Future<SessionUser?> restore();

  Future<LoginResult> login({
    required String identifier,
    required String password,
    required bool remember,
  });

  /// Tạo tài khoản và gửi OTP tới email.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  Future<OtpVerification> verifyOtp({
    required OtpPurpose purpose,
    required String email,
    required String code,
  });

  Future<void> resendOtp({required OtpPurpose purpose, required String email});

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  });

  /// Luôn xóa token cục bộ, kể cả khi gọi API lỗi.
  Future<void> logout();
}
