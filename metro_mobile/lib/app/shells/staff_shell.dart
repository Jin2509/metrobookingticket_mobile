import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/shells/staff_nav_items.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// Scaffold + bottom nav 4 tab, luôn dùng theme staff (nền navy).
class StaffShell extends StatelessWidget {
  const StaffShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MetroTheme.staff,
      child: Scaffold(
        body: shell,
        bottomNavigationBar: MetroBottomNav(
          items: staffNavItems(AppLocalizations.of(context)),
          currentIndex: shell.currentIndex,
          onTap: (i) =>
              shell.goBranch(i, initialLocation: i == shell.currentIndex),
        ),
      ),
    );
  }
}
