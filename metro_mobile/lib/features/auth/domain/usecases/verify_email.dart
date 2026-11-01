import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// Xác thực email đăng ký bằng OTP 6 số.
class VerifyEmail {
  const VerifyEmail(this._repo);
  final AuthRepository _repo;

  Future<void> call({required String email, required String code}) {
    final error = Validators.otp(code);
    if (error != null) throw ValidationFailure(error);
    return _repo.verifyEmail(email: email, code: code);
  }
}
