import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// Bật/tắt xác nhận 2 lớp, luôn cần mật khẩu hiện tại.
class SetTwoFactor {
  const SetTwoFactor(this._repo);
  final AuthRepository _repo;

  Future<SessionUser> call({
    required bool enabled,
    required String currentPassword,
  }) {
    final error = Validators.required(currentPassword, 'mật khẩu hiện tại');
    if (error != null) throw ValidationFailure(error);
    return _repo.setTwoFactor(
      enabled: enabled,
      currentPassword: currentPassword,
    );
  }
}
