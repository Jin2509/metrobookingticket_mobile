import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Vé lượt · Bến Thành → Thủ Đức`, hạn dùng, trạng thái.
class TicketQrInfo extends StatelessWidget {
  const TicketQrInfo({required this.ticket, super.key});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final t = ticket;
    return Column(
      children: [
        Text(t.typeName, style: context.text.titleLarge),
        if (t.hasRoute)
          RouteLabel(
            from: t.fromName!,
            to: t.toName!,
            style: context.text.bodyLarge,
          ),
        MetroSpacing.gapXs,
        Text(
          context.l10n.validUntil(dateTime(t.validUntil)),
          style: context.text.bodySmall,
        ),
        MetroSpacing.gapSm,
        StatusBadge(status: t.status),
        if (t.isUsable) ...[
          MetroSpacing.gapMd,
          Text(
            context.l10n.ticketQrHint,
            textAlign: TextAlign.center,
            style: context.text.bodySmall,
          ),
        ],
      ],
    );
  }
}
