import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// UC2-01 Đổi họ tên, yêu cầu đổi email. `currentPassword` chỉ bắt buộc khi
/// email thật sự thay đổi.
class UpdateProfile {
  const UpdateProfile(this._repo);
  final AuthRepository _repo;

  Future<SessionUser> call({
    required SessionUser user,
    required String name,
    required String email,
    required String currentPassword,
  }) {
    final next = email.trim();
    final changesEmail = next.toLowerCase() != user.email.toLowerCase();
    final error =
        Validators.fullName(name) ??
        Validators.email(next) ??
        (changesEmail
            ? Validators.required(currentPassword, 'mật khẩu')
            : null);
    if (error != null) throw ValidationFailure(error);
    return _repo.updateProfile(
      name: name.trim(),
      newEmail: changesEmail ? next : null,
      currentPassword: changesEmail ? currentPassword : null,
    );
  }
}
