import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `☐ Ghi nhớ đăng nhập      Quên MK? ▸`. Cả hàng checkbox bấm được.
class LoginOptionsRow extends StatelessWidget {
  const LoginOptionsRow({
    required this.remember,
    required this.onRememberChanged,
    super.key,
  });

  final bool remember;
  final ValueChanged<bool> onRememberChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            value: remember,
            onChanged: (v) => onRememberChanged(v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text(
              context.l10n.rememberMe,
              style: context.text.bodyMedium,
            ),
          ),
        ),
        TextButton(
          onPressed: () => context.push(Routes.forgot),
          child: Text(context.l10n.forgotPasswordLink),
        ),
      ],
    );
  }
}
