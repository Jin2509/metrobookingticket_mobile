import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// UC1-03 Quên mật khẩu: gửi OTP đặt lại tới email.
class ForgotPassword {
  const ForgotPassword(this._repo);
  final AuthRepository _repo;

  Future<void> call(String email) {
    final error = Validators.email(email);
    if (error != null) throw ValidationFailure(error);
    return _repo.forgotPassword(email.trim());
  }
}
