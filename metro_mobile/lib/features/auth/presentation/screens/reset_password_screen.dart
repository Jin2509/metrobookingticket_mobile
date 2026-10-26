import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/password/reset_password_form.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// A4 bước 3. Đặt mật khẩu mới (cần `resetToken` từ bước OTP).
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({required this.resetToken, super.key});

  final String? resetToken;

  @override
  Widget build(BuildContext context) {
    final token = resetToken;
    return AuthScaffold(
      title: context.l10n.newPassword,
      child: token == null
          ? ErrorState(
              title: context.l10n.resetSessionExpired,
              message: context.l10n.resetSessionExpiredBody,
              onRetry: () => context.go(Routes.forgot),
            )
          : ResetPasswordForm(resetToken: token),
    );
  }
}
