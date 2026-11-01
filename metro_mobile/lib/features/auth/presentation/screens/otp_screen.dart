import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/demo_hint.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_form.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// A3. Xác thực email đăng ký bằng OTP.
class OtpScreen extends StatelessWidget {
  const OtpScreen({required this.email, this.expiresIn, super.key});

  final String email;

  /// Thời gian còn lại của mã đã gửi trước đó.
  final Duration? expiresIn;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: context.l10n.otpTitleRegister,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text.rich(
            TextSpan(
              text: context.l10n.otpSentTo,
              children: [
                TextSpan(
                  text: maskEmail(email),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            style: context.text.bodyMedium,
          ),
          MetroSpacing.gapLg,
          OtpForm(email: email, expiresIn: expiresIn),
          DemoHint(lines: [context.l10n.demoOtp(AuthDemo.otp)]),
        ],
      ),
    );
  }
}
