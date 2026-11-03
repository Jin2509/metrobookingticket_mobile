import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_form_state.dart';

final forgotPasswordControllerProvider =
    NotifierProvider.autoDispose<ForgotPasswordController, AuthFormState>(
      ForgotPasswordController.new,
    );

final newPasswordControllerProvider =
    NotifierProvider.autoDispose<NewPasswordController, AuthFormState>(
      NewPasswordController.new,
    );

final resetOtpControllerProvider =
    NotifierProvider.autoDispose<ResetOtpController, AuthFormState>(
      ResetOtpController.new,
    );

/// A4 bước 1: kiểm tra email, chưa gửi mã.
class ForgotPasswordController extends AuthFormController {
  Future<bool> validate(String email) => runOk(() async {
    final error = Validators.email(email);
    if (error != null) throw ValidationFailure(error);
  });
}

/// A4 bước 2: mật khẩu mới hợp lệ thì mới gửi OTP.
class NewPasswordController extends AuthFormController {
  Future<bool> submit({
    required String email,
    required String password,
    required String confirm,
  }) => runOk(() async {
    final error =
        Validators.newPassword(password) ??
        Validators.confirm(confirm, password);
    if (error != null) throw ValidationFailure(error);
    await ref.read(forgotPasswordProvider).call(email);
  });
}

/// A4 bước 3: nhập OTP để hoàn tất đặt mật khẩu.
class ResetOtpController extends AuthFormController {
  Future<bool> submit({
    required String email,
    required String code,
    required String password,
  }) => runOk(
    () => ref
        .read(resetPasswordProvider)
        .call(email: email, code: code, password: password, confirm: password),
  );

  /// Yêu cầu mã mới; mã cũ mất hiệu lực.
  Future<bool> resend(String email) =>
      runOk(() => ref.read(forgotPasswordProvider).call(email));
}
