import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_link_row.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/demo_hint.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/login/login_form.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// A1. Đăng nhập (dùng chung Passenger và Staff).
class LoginScreen extends StatelessWidget {
  const LoginScreen({this.from, super.key});

  final String? from;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.login, style: context.text.titleLarge),
          MetroSpacing.gapLg,
          LoginForm(from: from),
          MetroSpacing.gapSm,
          AuthLinkRow(
            text: context.l10n.noAccount,
            action: context.l10n.register,
            onTap: () => context.push(Routes.register),
          ),
          DemoHint(
            lines: [
              context.l10n.demoPassword(AuthDemo.password),
              for (final e in AuthDemo.accounts.entries) '${e.key}: ${e.value}',
            ],
          ),
        ],
      ),
    );
  }
}
