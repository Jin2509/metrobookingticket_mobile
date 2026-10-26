import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// `Chưa có tài khoản? Đăng ký ▸`
class AuthLinkRow extends StatelessWidget {
  const AuthLinkRow({
    required this.text,
    required this.action,
    required this.onTap,
    super.key,
  });

  final String text;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(text, style: context.text.bodyMedium),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}
