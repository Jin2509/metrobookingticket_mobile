import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Lỗi dưới form (VD 401 "Sai thông tin đăng nhập").
class AuthErrorText extends StatelessWidget {
  const AuthErrorText(this.message, {super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: MetroSpacing.sm),
      child: Semantics(
        liveRegion: true,
        child: Text(
          localizeMessage(context.l10n, message!),
          style: context.text.bodySmall?.copyWith(
            color: context.metro.destructive,
          ),
        ),
      ),
    );
  }
}
