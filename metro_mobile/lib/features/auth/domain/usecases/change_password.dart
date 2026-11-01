import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// Đổi mật khẩu. Xong mọi thiết bị, kể cả máy này, phải đăng nhập lại.
class ChangePassword {
  const ChangePassword(this._repo);
  final AuthRepository _repo;

  Future<void> call({
    required String currentPassword,
    required String newPassword,
    required String confirm,
  }) {
    final error =
        Validators.required(currentPassword, 'mật khẩu') ??
        Validators.newPassword(newPassword) ??
        Validators.confirm(confirm, newPassword);
    if (error != null) throw ValidationFailure(error);
    return _repo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
