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
  Future<bool> submit(String email) =>
      runOk(() => ref.read(forgotPasswordProvider).call(email));
}

/// A4 bước 2: nhập OTP và đặt mật khẩu mới.
class ResetPasswordController extends AuthFormController {
  Future<bool> submit({
    required String email,
    required String code,
    required String password,
    required String confirm,
  }) => runOk(
    () => ref
        .read(resetPasswordProvider)
        .call(email: email, code: code, password: password, confirm: confirm),
  );

  /// Yêu cầu mã mới; mã cũ mất hiệu lực.
  Future<bool> resend(String email) =>
      runOk(() => ref.read(forgotPasswordProvider).call(email));
}
