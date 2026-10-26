import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// UC1-01 Đăng nhập.
class Login {
  const Login(this._repo);
  final AuthRepository _repo;

  Future<LoginResult> call({
    required String identifier,
    required String password,
    bool remember = true,
  }) {
    final error =
        Validators.emailOrPhone(identifier) ??
        Validators.required(password, 'mật khẩu');
    if (error != null) throw ValidationFailure(error);
    return _repo.login(
      identifier: identifier.trim(),
      password: password,
      remember: remember,
    );
  }
}
