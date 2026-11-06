import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/home/presentation/widgets/pass_tile.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/features/wallet/presentation/widgets/wallet_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Vé tàu và vé gửi xe trong một lưới hai ô dọc; có vé thì mở QR 1 chạm (P3),
/// chưa có thì dẫn tới chỗ mua. Vé còn lại xem ở tab Vé.
class ActivePassesSection extends ConsumerWidget {
  const ActivePassesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final tickets = ref.watch(activeTicketsProvider).value ?? const [];
    final parking = ref.watch(activeParkingProvider).value ?? const [];
    final t = tickets.firstOrNull;
    final p = parking.firstOrNull;
    final route = t?.fromName != null && t?.toName != null
        ? '${t!.fromName} → ${t.toName}'
        : t?.typeName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MetroSectionHeader(
          title: l.myTickets,
          actionLabel: l.viewAll,
          onAction: () => context.go(Routes.pTickets),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: t == null
                    ? PassTile(
                        icon: LucideIcons.ticket,
                        label: l.trainTickets,
                        title: l.homeNoTicket,
                        action: l.buyTicket,
                        onTap: () => context.push(Routes.buy()),
                      )
                    : PassTile(
                        icon: LucideIcons.ticket,
                        label: l.trainTickets,
                        title: route!,
                        subtitle: l.validUntilShort(dateTime(t.validUntil)),
                        action: l.openQr,
                        moreCount: tickets.length - 1,
                        onTap: () => context.push(Routes.ticketDetail(t.id)),
                      ),
              ),
              MetroSpacing.gapSm,
              Expanded(
                child: p == null
                    ? PassTile(
                        icon: LucideIcons.circleParking,
                        label: l.homeParkingPass,
                        title: l.homeNoParking,
                        action: l.parkingEntryAction,
                        onTap: () => context.push(Routes.pParkingBook),
                      )
                    : PassTile(
                        icon: vehicleKindOf(p.vehicleCode).icon,
                        label: l.homeParkingPass,
                        title: p.plate,
                        subtitle: p.lotName,
                        status: p.status,
                        action: l.openQr,
                        moreCount: parking.length - 1,
                        onTap: () => context.push(Routes.parkingPass(p.id)),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
