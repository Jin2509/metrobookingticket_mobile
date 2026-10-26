import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// UC1-04 Đăng xuất, có hộp xác nhận. Router tự về `/auth/login`.
class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.logoutConfirmTitle),
        content: Text(l.logoutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.logout),
          ),
        ],
      ),
    );
    if (ok ?? false) await ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MetroButton(
      label: AppLocalizations.of(context).logout,
      icon: LucideIcons.logOut,
      variant: MetroButtonVariant.outline,
      expand: true,
      onPressed: () => _confirm(context, ref),
    );
  }
}
