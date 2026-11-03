import 'package:flutter/material.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/history/parking_history_list.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/my_tickets/ticket_list.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Lịch sử đặt: vé và lượt gửi xe đã dùng xong hoặc hết hạn.
class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.bookingHistory),
          bottom: TabBar(
            tabs: [
              Tab(text: context.l10n.trainTickets),
              Tab(text: context.l10n.navParking),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TicketList(filter: TicketFilter.expired),
            ParkingHistoryList(),
          ],
        ),
      ),
    );
  }
}
