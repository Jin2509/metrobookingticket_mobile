import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// Xác nhận đổi email bằng OTP gửi tới email mới. Xong phải đăng nhập lại.
class VerifyNewEmail {
  const VerifyNewEmail(this._repo);
  final AuthRepository _repo;

  Future<void> call({required String email, required String code}) {
    final error = Validators.otp(code);
    if (error != null) throw ValidationFailure(error);
    return _repo.verifyNewEmail(email: email, code: code);
  }
}
