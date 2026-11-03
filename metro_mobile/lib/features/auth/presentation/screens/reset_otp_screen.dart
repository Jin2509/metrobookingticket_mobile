import 'package:flutter/material.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/password/reset_otp_form.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// A4 bước 3. Xác thực OTP sau khi đã nhập mật khẩu mới.
class ResetOtpScreen extends StatelessWidget {
  const ResetOtpScreen({required this.reset, super.key});

  final PendingPasswordReset reset;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: context.l10n.otpVerifyTitle,
      child: ResetOtpForm(reset: reset),
    );
  }
}
