import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// Gửi lại mã đăng nhập; mã cũ mất hiệu lực.
class ResendLoginCode {
  const ResendLoginCode(this._repo);
  final AuthRepository _repo;

  Future<void> call(String ticket) => _repo.resendLoginCode(ticket);
}
