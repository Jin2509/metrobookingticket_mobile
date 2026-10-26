import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// Gửi lại OTP (UC1-02). UI chặn 60s giữa hai lần gửi.
class ResendOtp {
  const ResendOtp(this._repo);
  final AuthRepository _repo;

  Future<void> call({required OtpPurpose purpose, required String email}) =>
      _repo.resendOtp(purpose: purpose, email: email);
}
