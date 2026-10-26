import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// Phiên hiện tại: loading = đang khôi phục, `null` = chưa đăng nhập.
final authControllerProvider =
    AsyncNotifierProvider<AuthController, SessionUser?>(AuthController.new);

class AuthController extends AsyncNotifier<SessionUser?> {
  @override
  Future<SessionUser?> build() {
    final sub = ref
        .read(sessionExpiredBusProvider)
        .stream
        .listen((_) => logout());
    ref.onDispose(sub.cancel);
    return ref.read(restoreSessionProvider).call();
  }

  void signedIn(SessionUser user) => state = AsyncData(user);

  /// Xóa token + phiên, router tự đưa về `/auth/login`.
  Future<void> logout() async {
    await ref.read(logoutProvider).call();
    state = const AsyncData(null);
  }
}
