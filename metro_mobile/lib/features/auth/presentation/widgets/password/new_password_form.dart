import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/password_controllers.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nhập mật khẩu mới, hợp lệ thì gửi OTP và sang màn xác thực.
class NewPasswordForm extends ConsumerStatefulWidget {
  const NewPasswordForm({required this.email, super.key});

  final String email;

  @override
  ConsumerState<NewPasswordForm> createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends ConsumerState<NewPasswordForm> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final ctrl = ref.read(newPasswordControllerProvider.notifier);
    final ok = await ctrl.submit(
      email: widget.email,
      password: _password.text,
      confirm: _confirm.text,
    );
    if (!mounted) return;
    // Vừa gửi mã rồi quay lại sửa mật khẩu: mã trong mail vẫn dùng được.
    final codeStillValid =
        ref.read(newPasswordControllerProvider).retryAfter != null;
    if (!ok && !codeStillValid) return;
    ctrl.clearError();
    await context.push(
      Routes.resetOtp,
      extra: PendingPasswordReset(
        email: widget.email,
        newPassword: _password.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newPasswordControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MascotTip(text: context.l10n.newPasswordIntro),
        MetroSpacing.gapLg,
        PasswordField(
          label: context.l10n.newPassword,
          controller: _password,
          showStrength: true,
        ),
        MetroSpacing.gapMd,
        PasswordField(
          label: context.l10n.confirmNewPassword,
          controller: _confirm,
        ),
        MetroSpacing.gapLg,
        MetroButton(
          label: context.l10n.sendCode,
          size: MetroButtonSize.lg,
          expand: true,
          loading: state.submitting,
          onPressed: _submit,
        ),
        AuthErrorText(state.error),
      ],
    );
  }
}
