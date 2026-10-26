import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/validators.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/demo_hint.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/otp/otp_form.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// A3. Xác thực OTP cho đăng ký, đăng nhập 2 lớp, quên mật khẩu.
class OtpScreen extends StatelessWidget {
  const OtpScreen({required this.purpose, required this.email, super.key});

  final OtpPurpose purpose;
  final String email;

  String _title(AppLocalizations l) => switch (purpose) {
    OtpPurpose.register => l.otpTitleRegister,
    OtpPurpose.login2fa => l.otpTitle2fa,
    OtpPurpose.reset => l.otpTitleReset,
  };

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: _title(context.l10n),
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
          OtpForm(purpose: purpose, email: email),
          DemoHint(lines: [context.l10n.demoOtp(AuthDemo.otp)]),
        ],
      ),
    );
  }
}
