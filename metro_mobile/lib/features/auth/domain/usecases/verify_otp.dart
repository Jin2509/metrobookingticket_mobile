import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// Xác thực OTP 6 số cho REGISTER / LOGIN_2FA / RESET.
class VerifyOtp {
  const VerifyOtp(this._repo);
  final AuthRepository _repo;

  static final _code = RegExp(r'^\d{6}$');

  Future<OtpVerification> call({
    required OtpPurpose purpose,
    required String email,
    required String code,
  }) {
    if (!_code.hasMatch(code)) {
      throw const ValidationFailure('Mã OTP gồm 6 chữ số');
    }
    return _repo.verifyOtp(purpose: purpose, email: email, code: code);
  }
}
