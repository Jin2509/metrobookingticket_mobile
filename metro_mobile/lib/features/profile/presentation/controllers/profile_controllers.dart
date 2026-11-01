import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/auth/auth_providers.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_form_state.dart';

final profileControllerProvider =
    NotifierProvider.autoDispose<ProfileController, AuthFormState>(
      ProfileController.new,
    );

final verifyNewEmailControllerProvider =
    NotifierProvider.autoDispose<VerifyNewEmailController, AuthFormState>(
      VerifyNewEmailController.new,
    );

final changePasswordControllerProvider =
    NotifierProvider.autoDispose<ChangePasswordController, AuthFormState>(
      ChangePasswordController.new,
    );

final twoFactorSettingControllerProvider =
    NotifierProvider.autoDispose<TwoFactorSettingController, AuthFormState>(
      TwoFactorSettingController.new,
    );

/// Họ tên đổi ngay; email trong phản hồi vẫn là email cũ tới khi xác nhận OTP.
class ProfileController extends AuthFormController {
  Future<bool> save({
    required SessionUser user,
    required String name,
    required String email,
    required String currentPassword,
  }) async {
    final updated = await run(
      () => ref
          .read(updateProfileProvider)
          .call(
            user: user,
            name: name,
            email: email,
            currentPassword: currentPassword,
          ),
    );
    if (updated == null) return false;
    ref.read(authControllerProvider.notifier).signedIn(updated);
    return true;
  }
}

/// Xong thì mọi token bị thu hồi: phiên kết thúc, router về đăng nhập.
class VerifyNewEmailController extends AuthFormController {
  Future<bool> verify({required String email, required String code}) async {
    final auth = ref.read(authControllerProvider.notifier);
    final ok = await runOk(
      () => ref.read(verifyNewEmailProvider).call(email: email, code: code),
    );
    if (ok) auth.signedOut();
    return ok;
  }
}

/// Bật/tắt xác nhận 2 lớp, phiên hiện tại giữ nguyên.
class TwoFactorSettingController extends AuthFormController {
  Future<bool> submit({
    required bool enabled,
    required String currentPassword,
  }) async {
    final updated = await run(
      () => ref
          .read(setTwoFactorProvider)
          .call(enabled: enabled, currentPassword: currentPassword),
    );
    if (updated == null) return false;
    ref.read(authControllerProvider.notifier).signedIn(updated);
    return true;
  }
}

/// Xong thì mọi token bị thu hồi: phiên kết thúc, router về đăng nhập.
class ChangePasswordController extends AuthFormController {
  Future<bool> submit({
    required String currentPassword,
    required String newPassword,
    required String confirm,
  }) async {
    final auth = ref.read(authControllerProvider.notifier);
    final ok = await runOk(
      () => ref
          .read(changePasswordProvider)
          .call(
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirm: confirm,
          ),
    );
    if (ok) auth.signedOut();
    return ok;
  }
}
