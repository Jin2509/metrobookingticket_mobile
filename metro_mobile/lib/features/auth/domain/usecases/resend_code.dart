import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// Gửi lại OTP đăng ký (UC1-02). Backend chặn 60s giữa hai lần gửi.
class ResendCode {
  const ResendCode(this._repo);
  final AuthRepository _repo;

  Future<void> call(String email) => _repo.resendCode(email);
}
