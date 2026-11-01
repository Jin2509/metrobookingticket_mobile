import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// Phiên hiện tại: loading = đang khôi phục, `null` = chưa đăng nhập.
final authControllerProvider =
    AsyncNotifierProvider<AuthController, SessionUser?>(AuthController.new);

class AuthController extends AsyncNotifier<SessionUser?> {
  @override
  Future<SessionUser?> build() {
    final sub = ref.read(sessionEventBusProvider).stream.listen((event) {
      switch (event) {
        case SessionEvent.expired:
          signedOut();
        case SessionEvent.refreshed:
          unawaited(_reloadUser());
      }
    });
    ref.onDispose(sub.cancel);
    return ref.read(restoreSessionProvider).call();
  }

  void signedIn(SessionUser user) => state = AsyncData(user);

  /// Token đã bị xóa/thu hồi, router tự đưa về `/auth/login`.
  void signedOut() => state = const AsyncData(null);

  /// Xóa token + phiên, router tự đưa về `/auth/login`.
  Future<void> logout() async {
    await ref.read(logoutProvider).call();
    signedOut();
  }

  /// Sau refresh vai trò/quyền có thể đã đổi. Lỗi thì giữ thông tin cũ.
  Future<void> _reloadUser() async {
    if (state.value == null) return;
    try {
      final user = await ref.read(authRepositoryProvider).reloadUser();
      if (state.value != null) state = AsyncData(user);
    } on Failure {
      return;
    }
  }
}
