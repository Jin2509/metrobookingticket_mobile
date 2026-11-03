/// Đăng nhập đang chờ bước 2. Chỉ giữ trong bộ nhớ, không ghi xuống thiết bị.
class TwoFactorLogin {
  const TwoFactorLogin({
    required this.email,
    required this.ticket,
    required this.remember,
    this.expiresIn,
  });

  final String email;
  final String ticket;
  final bool remember;

  /// Thời gian còn lại của mã.
  final Duration? expiresIn;
}

/// Kết quả đăng ký: đã gửi mã, hoặc email đang chờ xác thực và mã cũ còn hiệu
/// lực (429). Khi đó mật khẩu vừa nhập KHÔNG được lưu.
class RegisterResult {
  const RegisterResult({this.alreadyPending = false, this.codeExpiresIn});

  final bool alreadyPending;

  /// Thời gian còn lại của mã cũ, từ header `Retry-After`.
  final Duration? codeExpiresIn;
}

/// Yêu cầu đặt lại mật khẩu đang chờ OTP. Chỉ truyền trong bộ nhớ qua `extra`,
/// không nằm trên URL vì có mật khẩu mới.
class PendingPasswordReset {
  const PendingPasswordReset({required this.email, required this.newPassword});

  final String email;
  final String newPassword;
}
