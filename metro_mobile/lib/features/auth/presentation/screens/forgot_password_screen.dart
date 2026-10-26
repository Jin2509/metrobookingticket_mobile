import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/password/forgot_password_form.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// A4 bước 1. Quên mật khẩu.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: context.l10n.forgotPasswordTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.forgotPasswordIntro,
            style: context.text.bodyMedium,
          ),
          MetroSpacing.gapLg,
          const ForgotPasswordForm(),
        ],
      ),
    );
  }
}
