import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_form_state.dart';

final otpControllerProvider =
    NotifierProvider.autoDispose<OtpController, AuthFormState>(
      OtpController.new,
    );

/// Xác thực email đăng ký. Xong phải đăng nhập (backend không tự đăng nhập).
class OtpController extends AuthFormController {
  Future<bool> verify({required String email, required String code}) =>
      runOk(() => ref.read(verifyEmailProvider).call(email: email, code: code));

  Future<bool> resend(String email) =>
      runOk(() => ref.read(resendCodeProvider).call(email));
}
