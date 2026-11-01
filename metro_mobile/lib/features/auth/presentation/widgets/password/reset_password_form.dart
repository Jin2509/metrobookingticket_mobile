import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/password_controllers.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/demo_hint.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_expiry_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_resend_button.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nhập OTP và mật khẩu mới cùng lúc (`reset-password` kiểm tra cả hai), xong
/// quay về đăng nhập.
class ResetPasswordForm extends ConsumerStatefulWidget {
  const ResetPasswordForm({required this.email, super.key});

  final String email;

  @override
  ConsumerState<ResetPasswordForm> createState() => _ResetFormState();
}

class _ResetFormState extends ConsumerState<ResetPasswordForm> {
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  int _round = 0;

  ResetPasswordController get _ctrl =>
      ref.read(resetPasswordControllerProvider.notifier);

  @override
  void dispose() {
    for (final c in [_code, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final ok = await _ctrl.submit(
      email: widget.email,
      code: _code.text,
      password: _password.text,
      confirm: _confirm.text,
    );
    if (!ok || !mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.resetPasswordDone)));
    context.go(Routes.login);
  }

  Future<Duration?> _resend() async {
    final ok = await _ctrl.resend(widget.email);
    if (!mounted) return null;
    if (!ok) return ref.read(resetPasswordControllerProvider).retryAfter;
    _code.clear();
    setState(() => _round++);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.otpResent)));
    return OtpResendButton.cooldown;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resetPasswordControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.otpSentIfExists(maskEmail(widget.email)),
          style: context.text.bodyMedium,
        ),
        MetroSpacing.gapLg,
        OtpInput(controller: _code, autofocus: true),
        MetroSpacing.gapMd,
        OtpExpiryText(key: ValueKey(_round)),
        Align(
          alignment: Alignment.centerLeft,
          child: OtpResendButton(onResend: _resend),
        ),
        MetroSpacing.gapSm,
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
          label: context.l10n.saveNewPassword,
          size: MetroButtonSize.lg,
          expand: true,
          loading: state.submitting,
          onPressed: _submit,
        ),
        AuthErrorText(state.error),
        DemoHint(lines: [context.l10n.demoOtp(AuthDemo.otp)]),
      ],
    );
  }
}
