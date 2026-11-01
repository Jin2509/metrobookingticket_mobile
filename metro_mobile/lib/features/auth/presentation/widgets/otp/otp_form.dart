import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/otp_controller.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_expiry_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_resend_button.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nhập OTP xác thực email. Xong quay về đăng nhập vì backend không tự đăng
/// nhập.
class OtpForm extends ConsumerStatefulWidget {
  const OtpForm({required this.email, this.expiresIn, super.key});

  final String email;

  /// Thời gian còn lại của mã đã gửi trước đó.
  final Duration? expiresIn;

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
    final ok = await _ctrl.verify(email: widget.email, code: _code.text);
    if (!ok || !mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.emailVerifiedDone)));
    context.go(Routes.login);
  }

  Future<Duration?> _resend() async {
    final ok = await _ctrl.resend(widget.email);
    if (!mounted) return null;
    if (!ok) return ref.read(otpControllerProvider).retryAfter;
    _code.clear();
    setState(() => _round++);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.otpResent)));
    return OtpResendButton.cooldown;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpControllerProvider);
    final expiresIn = widget.expiresIn;
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
        if (_round == 0 && expiresIn != null)
          OtpExpiryText(key: ValueKey(_round), ttl: expiresIn)
        else
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
