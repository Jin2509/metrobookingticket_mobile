import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/shells/passenger_nav_items.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// Scaffold + bottom nav 5 tab, giữ state từng tab (StatefulShellRoute).
class PassengerShell extends StatelessWidget {
  const PassengerShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: MetroBottomNav(
        items: passengerNavItems(AppLocalizations.of(context)),
        currentIndex: shell.currentIndex,
        onTap: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}
