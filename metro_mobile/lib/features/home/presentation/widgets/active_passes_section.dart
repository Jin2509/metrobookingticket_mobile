import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/wallet_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Vé đang hiệu lực + lượt gửi xe; mở QR 1 chạm (P3).
class ActivePassesSection extends ConsumerWidget {
  const ActivePassesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(activeTicketsProvider).value ?? const [];
    final parking = ref.watch(activeParkingProvider).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.activePasses,
                style: context.text.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () => context.go(Routes.pTickets),
              child: Text(context.l10n.viewAll),
            ),
          ],
        ),
        if (tickets.isEmpty && parking.isEmpty)
          Text(context.l10n.noActivePasses, style: context.text.bodySmall),
        for (final t in tickets.take(2)) ...[
          TicketCard(
            title: t.typeName,
            from: t.fromName,
            to: t.toName,
            status: t.status,
            validUntil: t.validUntil,
            onOpenQr: () => context.push(Routes.ticketDetail(t.id)),
          ),
          MetroSpacing.gapSm,
        ],
        for (final p in parking.take(1))
          ParkingPassCard(
            lotName: p.lotName,
            plate: p.plate,
            vehicle: vehicleKindOf(p.vehicleCode),
            status: p.status,
            since: p.since,
            onOpenQr: () => context.push(Routes.parkingPass(p.id)),
          ),
      ],
    );
  }
}
