import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/password_controllers.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/demo_hint.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_expiry_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_resend_button.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nhập OTP để hoàn tất đặt lại mật khẩu, xong quay về đăng nhập.
class ResetOtpForm extends ConsumerStatefulWidget {
  const ResetOtpForm({required this.reset, super.key});

  final PendingPasswordReset reset;

  @override
  ConsumerState<ResetOtpForm> createState() => _ResetOtpFormState();
}

class _ResetOtpFormState extends ConsumerState<ResetOtpForm> {
  final _code = TextEditingController();
  int _round = 0;

  ResetOtpController get _ctrl => ref.read(resetOtpControllerProvider.notifier);

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await _ctrl.submit(
      email: widget.reset.email,
      code: _code.text,
      password: widget.reset.newPassword,
    );
    if (!ok || !mounted) return;
    MascotToast.of(context)(context.l10n.resetPasswordDone);
    context.go(Routes.login);
  }

  Future<Duration?> _resend() async {
    final ok = await _ctrl.resend(widget.reset.email);
    if (!mounted) return null;
    if (!ok) return ref.read(resetOtpControllerProvider).retryAfter;
    _code.clear();
    setState(() => _round++);
    MascotToast.of(context)(context.l10n.otpResent);
    return OtpResendButton.cooldown;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resetOtpControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MascotTip(
          text: context.l10n.otpSentIfExists(maskEmail(widget.reset.email)),
        ),
        MetroSpacing.gapLg,
        OtpInput(
          controller: _code,
          autofocus: true,
          hasError: state.error != null,
          onChanged: (_) {
            if (state.error != null) _ctrl.clearError();
          },
          onCompleted: (_) => _submit(),
        ),
        AuthErrorText(state.error),
        MetroSpacing.gapMd,
        OtpExpiryText(key: ValueKey(_round)),
        Align(
          alignment: Alignment.centerLeft,
          child: OtpResendButton(onResend: _resend),
        ),
        MetroSpacing.gapSm,
        MetroButton(
          label: context.l10n.saveNewPassword,
          size: MetroButtonSize.lg,
          expand: true,
          loading: state.submitting,
          onPressed: _submit,
        ),
        DemoHint(lines: [context.l10n.demoOtp(AuthDemo.otp)]),
      ],
    );
  }
}
