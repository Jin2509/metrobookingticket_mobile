import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// Bước 2 của đăng nhập: nhập mã gửi qua email.
class VerifyLoginCode {
  const VerifyLoginCode(this._repo);
  final AuthRepository _repo;

  Future<SessionUser> call({
    required String ticket,
    required String code,
    required bool remember,
  }) {
    final error = Validators.otp(code);
    if (error != null) throw ValidationFailure(error);
    return _repo.verifyLoginCode(
      ticket: ticket,
      code: code,
      remember: remember,
    );
  }
}
