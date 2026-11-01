import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

/// Splash: còn phiên hợp lệ thì vào thẳng shell theo vai trò.
class RestoreSession {
  const RestoreSession(this._repo);
  final AuthRepository _repo;

  Future<SessionUser?> call() async {
    try {
      return await _repo.restore();
    } on Object {
      return null;
    }
  }
}
