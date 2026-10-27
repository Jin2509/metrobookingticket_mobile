import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/my_tickets/parking_passes_tab.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/my_tickets/tickets_tab.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P40. Vé của tôi: `[Vé tàu][Gửi xe]`.
class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _Bar(),
        body: TabBarView(children: [TicketsTab(), ParkingPassesTab()]),
      ),
    );
  }
}

class _Bar extends StatelessWidget implements PreferredSizeWidget {
  const _Bar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.l10n.myTickets),
      actions: [
        TextButton.icon(
          onPressed: () => context.push(Routes.buy()),
          icon: const Icon(LucideIcons.ticketPlus, size: 18),
          label: Text(context.l10n.buyTicket),
        ),
        MetroSpacing.gapXs,
      ],
      bottom: TabBar(
        tabs: [
          Tab(text: context.l10n.trainTickets),
          Tab(text: context.l10n.navParking),
        ],
      ),
    );
  }
}
