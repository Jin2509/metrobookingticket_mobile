import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// UC1-04 Đăng xuất.
class Logout {
  const Logout(this._repo);
  final AuthRepository _repo;

  Future<void> call() => _repo.logout();
}
