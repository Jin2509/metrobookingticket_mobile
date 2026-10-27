import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/app/shells/passenger_nav_items.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/chatbot/presentation/widgets/chat_sheet.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// Scaffold + bottom nav 4 tab, giữ state từng tab (StatefulShellRoute).
/// Nút Trợ lý nổi chỉ hiện ở màn gốc của tab để không che nút hành động
/// ở các màn con.
class PassengerShell extends StatelessWidget {
  const PassengerShell({
    required this.shell,
    required this.location,
    super.key,
  });

  final StatefulNavigationShell shell;
  final String location;

  static const _tabRoots = {
    Routes.pHome,
    Routes.pExplore,
    Routes.pTickets,
    Routes.pAccount,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      floatingActionButton: _tabRoots.contains(location)
          ? FloatingActionButton(
              heroTag: 'assistant',
              tooltip: l.assistantTitle,
              onPressed: () => ChatSheet.show(context),
              child: const Icon(LucideIcons.botMessageSquare),
            )
          : null,
      bottomNavigationBar: MetroBottomNav(
        items: passengerNavItems(l),
        currentIndex: shell.currentIndex,
        onTap: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}
