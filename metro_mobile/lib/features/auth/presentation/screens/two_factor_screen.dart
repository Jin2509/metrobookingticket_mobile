import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/two_factor_controller.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_error_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/demo_hint.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_expiry_text.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_resend_button.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Xác nhận 2 lớp khi đăng nhập: nhập mã 6 số gửi qua email.
class TwoFactorScreen extends ConsumerStatefulWidget {
  const TwoFactorScreen({required this.login, super.key});

  final TwoFactorLogin login;

  @override
  ConsumerState<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends ConsumerState<TwoFactorScreen> {
  final _code = TextEditingController();
  int _round = 0;

  TwoFactorController get _ctrl =>
      ref.read(twoFactorControllerProvider.notifier);

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() => _ctrl.verify(widget.login, _code.text);

  Future<Duration?> _resend() async {
    final ok = await _ctrl.resend(widget.login);
    if (!mounted) return null;
    if (!ok) return ref.read(twoFactorControllerProvider).retryAfter;
    _code.clear();
    setState(() => _round++);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.otpResent)));
    return OtpResendButton.cooldown;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(twoFactorControllerProvider);
    final expiresIn = widget.login.expiresIn;
    return AuthScaffold(
      title: context.l10n.loginTwoFactorTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(
              text: context.l10n.otpSentTo,
              children: [
                TextSpan(
                  text: maskEmail(widget.login.email),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            style: context.text.bodyMedium,
          ),
          MetroSpacing.gapLg,
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
          DemoHint(lines: [context.l10n.demoOtp(AuthDemo.otp)]),
        ],
      ),
    );
  }
}
