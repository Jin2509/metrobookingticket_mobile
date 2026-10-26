import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_link_row.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/register/register_form.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// A2. Tạo tài khoản hành khách.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: context.l10n.registerTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RegisterForm(),
          MetroSpacing.gapSm,
          AuthLinkRow(
            text: context.l10n.haveAccount,
            action: context.l10n.login,
            onTap: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
