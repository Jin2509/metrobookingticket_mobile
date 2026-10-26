import 'package:flutter/material.dart';
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
      bottom: TabBar(
        tabs: [
          Tab(text: context.l10n.trainTickets),
          Tab(text: context.l10n.navParking),
        ],
      ),
    );
  }
}
