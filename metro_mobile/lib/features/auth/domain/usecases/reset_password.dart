import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// UC1-03 Đặt mật khẩu mới bằng OTP gửi tới email.
class ResetPassword {
  const ResetPassword(this._repo);
  final AuthRepository _repo;

  Future<void> call({
    required String email,
    required String code,
    required String password,
    required String confirm,
  }) {
    final error =
        Validators.otp(code) ??
        Validators.newPassword(password) ??
        Validators.confirm(confirm, password);
    if (error != null) throw ValidationFailure(error);
    return _repo.resetPassword(email: email, code: code, newPassword: password);
  }
}
