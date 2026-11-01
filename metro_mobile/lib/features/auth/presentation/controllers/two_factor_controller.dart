import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_form_state.dart';

final twoFactorControllerProvider =
    NotifierProvider.autoDispose<TwoFactorController, AuthFormState>(
      TwoFactorController.new,
    );

/// Bước 2 của đăng nhập. Thành công thì cập nhật phiên, router tự chuyển màn.
class TwoFactorController extends AuthFormController {
  Future<void> verify(TwoFactorLogin login, String code) async {
    final auth = ref.read(authControllerProvider.notifier);
    final user = await run(
      () => ref
          .read(verifyLoginCodeProvider)
          .call(ticket: login.ticket, code: code, remember: login.remember),
    );
    if (user != null) auth.signedIn(user);
  }

  Future<bool> resend(TwoFactorLogin login) =>
      runOk(() => ref.read(resendLoginCodeProvider).call(login.ticket));
}
