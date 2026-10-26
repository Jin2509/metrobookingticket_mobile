import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// ADMIN / MANAGER / ACCOUNTANT đăng nhập app (giống `AccessDenied` web).
class UnsupportedRoleScreen extends ConsumerWidget {
  const UnsupportedRoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Theme(
      data: MetroTheme.staff,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: EmptyState(
              icon: LucideIcons.monitor,
              title: l.unsupportedTitle,
              message: l.unsupportedBody,
              actionLabel: l.logout,
              actionVariant: MetroButtonVariant.outline,
              onAction: () =>
                  ref.read(authControllerProvider.notifier).logout(),
            ),
          ),
        ),
      ),
    );
  }
}
