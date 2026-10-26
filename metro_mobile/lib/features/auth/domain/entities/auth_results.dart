import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// Kết quả đăng nhập: vào thẳng, hoặc cần OTP email (flow 7.1).
sealed class LoginResult {
  const LoginResult();
}

class LoginSucceeded extends LoginResult {
  const LoginSucceeded(this.user);
  final SessionUser user;
}

class LoginNeedsOtp extends LoginResult {
  const LoginNeedsOtp(this.email);
  final String email;
}

/// Kết quả xác thực OTP theo mục đích.
sealed class OtpVerification {
  const OtpVerification();
}

/// REGISTER / LOGIN_2FA: đã có phiên.
class OtpSignedIn extends OtpVerification {
  const OtpSignedIn(this.user);
  final SessionUser user;
}

/// RESET: được phép đặt mật khẩu mới bằng [resetToken].
class OtpResetAllowed extends OtpVerification {
  const OtpResetAllowed(this.resetToken);
  final String resetToken;
}
