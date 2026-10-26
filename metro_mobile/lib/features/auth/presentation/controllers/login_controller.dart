import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_form_state.dart';

final loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, AuthFormState>(
      LoginController.new,
    );

class LoginController extends AuthFormController {
  /// Đăng nhập thẳng thì cập nhật phiên; cần 2FA thì trả về để mở OTP.
  Future<LoginResult?> submit({
    required String identifier,
    required String password,
    required bool remember,
  }) async {
    final result = await run(
      () => ref
          .read(loginProvider)
          .call(identifier: identifier, password: password, remember: remember),
    );
    if (result is LoginSucceeded) {
      ref.read(authControllerProvider.notifier).signedIn(result.user);
    }
    return result;
  }
}
