import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// UC1-01 Đăng nhập.
class Login {
  const Login(this._repo);
  final AuthRepository _repo;

  Future<SessionUser> call({
    required String email,
    required String password,
    bool remember = true,
  }) {
    final error =
        Validators.email(email) ?? Validators.required(password, 'mật khẩu');
    if (error != null) throw ValidationFailure(error);
    return _repo.login(
      email: email.trim(),
      password: password,
      remember: remember,
    );
  }
}
