import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/my_tickets/ticket_filter_chips.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/my_tickets/ticket_list.dart';

/// Tab "Vé tàu": chip lọc + danh sách.
class TicketsTab extends StatefulWidget {
  const TicketsTab({super.key});

  @override
  State<TicketsTab> createState() => _TicketsTabState();
}

class _TicketsTabState extends State<TicketsTab> {
  TicketFilter _filter = TicketFilter.all;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MetroSpacing.gapSm,
        TicketFilterChips(
          value: _filter,
          onChanged: (f) => setState(() => _filter = f),
        ),
        Expanded(child: TicketList(filter: _filter)),
      ],
    );
  }
}
