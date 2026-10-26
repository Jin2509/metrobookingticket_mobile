import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Vé ngày / 3 ngày / tháng: giá cố định, thời hạn.
class PeriodPassList extends StatelessWidget {
  const PeriodPassList({required this.types, super.key});

  final List<TicketType> types;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: context.l10n.periodPassTitle,
      child: Column(
        children: [
          for (final t in types.where((t) => !t.needsStations))
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(t.name, style: context.text.bodyLarge),
              subtitle: Text(t.validity, style: context.text.bodySmall),
              trailing: MoneyText(t.price!, style: context.text.titleSmall),
            ),
        ],
      ),
    );
  }
}
