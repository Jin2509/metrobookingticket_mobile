import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_form_state.dart';

final loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, AuthFormState>(
      LoginController.new,
    );

class LoginController extends AuthFormController {
  /// Thành công thì cập nhật phiên. Email chưa xác thực: gửi lại mã rồi để form
  /// mở màn OTP (xem `state.unverified`).
  Future<void> submit({
    required String email,
    required String password,
    required bool remember,
  }) async {
    final user = await run(
      () => ref
          .read(loginProvider)
          .call(email: email, password: password, remember: remember),
    );
    if (user != null) {
      ref.read(authControllerProvider.notifier).signedIn(user);
    } else if (ref.mounted && state.unverified) {
      await _resend(email);
    }
  }

  /// 429 nghĩa là mã vừa gửi còn dùng được, nên bỏ qua lỗi.
  Future<void> _resend(String email) async {
    try {
      await ref.read(resendCodeProvider).call(email.trim());
    } on Failure {
      return;
    }
  }
}
