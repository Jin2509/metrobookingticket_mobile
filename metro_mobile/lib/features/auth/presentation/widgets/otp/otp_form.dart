import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/otp_controller.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_expiry_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_resend_button.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nhập OTP. Đăng nhập/đăng ký xong thì router tự chuyển shell;
/// RESET thì sang màn đặt mật khẩu mới.
class OtpForm extends ConsumerStatefulWidget {
  const OtpForm({required this.purpose, required this.email, super.key});

  final OtpPurpose purpose;
  final String email;

  @override
  ConsumerState<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends ConsumerState<OtpForm> {
  final _code = TextEditingController();
  int _round = 0;

  OtpController get _ctrl => ref.read(otpControllerProvider.notifier);

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final result = await _ctrl.verify(
      purpose: widget.purpose,
      email: widget.email,
      code: _code.text,
    );
    if (!mounted || result is! OtpResetAllowed) return;
    context.pushReplacement(Routes.resetWith(result.resetToken));
  }

  Future<bool> _resend() async {
    final ok = await _ctrl.resend(purpose: widget.purpose, email: widget.email);
    if (ok && mounted) {
      _code.clear();
      setState(() => _round++);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.otpResent)));
    }
    return ok;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OtpInput(
          controller: _code,
          autofocus: true,
          hasError: state.error != null,
          onChanged: (_) {
            if (state.error != null) _ctrl.clearError();
          },
          onCompleted: (_) => _verify(),
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
          label: context.l10n.confirm,
          size: MetroButtonSize.lg,
          expand: true,
          loading: state.submitting,
          onPressed: _verify,
        ),
      ],
    );
  }
}
