import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// UC1-03 Đặt mật khẩu mới sau khi xác thực OTP.
class ResetPassword {
  const ResetPassword(this._repo);
  final AuthRepository _repo;

  Future<void> call({
    required String resetToken,
    required String password,
    required String confirm,
  }) {
    final error =
        Validators.newPassword(password) ??
        Validators.confirm(confirm, password);
    if (error != null) throw ValidationFailure(error);
    return _repo.resetPassword(resetToken: resetToken, newPassword: password);
  }
}
