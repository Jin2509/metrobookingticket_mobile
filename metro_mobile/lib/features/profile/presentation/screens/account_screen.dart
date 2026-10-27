import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/profile/presentation/widgets/account_header.dart';
import 'package:metro_mobile/features/profile/presentation/widgets/account_menu.dart';
import 'package:metro_mobile/features/profile/presentation/widgets/account_menu_items.dart';
import 'package:metro_mobile/features/profile/presentation/widgets/app_settings_section.dart';
import 'package:metro_mobile/features/profile/presentation/widgets/logout_button.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// P50 / S40. Tab Tài khoản, dùng chung 2 vai trò.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.accountTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          MetroSpacing.md,
          MetroSpacing.md,
          MetroSpacing.md,
          MetroSpacing.fabClearance,
        ),
        children: [
          AccountHeader(user: user),
          MetroSpacing.gapMd,
          AccountMenu(items: accountMenuFor(user.role, l)),
          MetroSpacing.gapMd,
          AppSettingsSection(showAppearance: user.role == Role.passenger),
          MetroSpacing.gapLg,
          const LogoutButton(),
        ],
      ),
    );
  }
}
