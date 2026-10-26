import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// UC1-02 Đăng ký (gửi OTP sau khi tạo).
class Register {
  const Register(this._repo);
  final AuthRepository _repo;

  Future<void> call({
    required String name,
    required String email,
    required String password,
    required String confirm,
    required bool acceptedTerms,
  }) {
    final error =
        Validators.required(name, 'họ tên') ??
        Validators.email(email) ??
        Validators.newPassword(password) ??
        Validators.confirm(confirm, password) ??
        (acceptedTerms ? null : 'Vui lòng đồng ý điều khoản sử dụng');
    if (error != null) throw ValidationFailure(error);
    return _repo.register(
      name: name.trim(),
      email: email.trim(),
      password: password,
    );
  }
}
