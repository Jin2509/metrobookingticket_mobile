import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_form_state.dart';

final forgotPasswordControllerProvider =
    NotifierProvider.autoDispose<ForgotPasswordController, AuthFormState>(
      ForgotPasswordController.new,
    );

final resetPasswordControllerProvider =
    NotifierProvider.autoDispose<ResetPasswordController, AuthFormState>(
      ResetPasswordController.new,
    );

/// A4 bước 1: gửi OTP đặt lại mật khẩu.
class ForgotPasswordController extends AuthFormController {
  Future<bool> submit(String email) async {
    final ok = await run(() async {
      await ref.read(forgotPasswordProvider).call(email);
      return true;
    });
    return ok ?? false;
  }
}

/// A4 bước 3: đặt mật khẩu mới.
class ResetPasswordController extends AuthFormController {
  Future<bool> submit({
    required String resetToken,
    required String password,
    required String confirm,
  }) async {
    final ok = await run(() async {
      await ref
          .read(resetPasswordProvider)
          .call(resetToken: resetToken, password: password, confirm: confirm);
      return true;
    });
    return ok ?? false;
  }
}
