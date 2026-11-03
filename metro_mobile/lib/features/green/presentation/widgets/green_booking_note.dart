import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/controllers/green_controller.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/features/network/network_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/wallet/presentation/controllers/wallet_controllers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// CO2 chuyến vừa đặt sẽ bớt được. `null`: vé không có ga đi/đến.
final bookedTripKgProvider = FutureProvider.autoDispose.family<double?, String>(
  (ref, ticketId) async {
    final ticket = await ref.watch(ticketDetailProvider(ticketId).future);
    if (!ticket.hasRoute) return null;
    final catalog = await ref.watch(catalogProvider.future);
    String? id(String? name) =>
        catalog.stations.values.where((s) => s.name == name).firstOrNull?.id;
    final plan = await ref
        .watch(searchRouteProvider)
        .call(id(ticket.fromName), id(ticket.toName));
    return TravelMode.motorbike.savedKg(routeKm(plan, catalog));
  },
);

/// Thông báo Hành trình xanh sau khi đặt xong. Lượng CO2 chỉ được cộng khi đi
/// xong chuyến nên nói rõ là "sẽ".
class GreenBookingNote extends ConsumerWidget {
  const GreenBookingNote({this.ticketId, super.key});

  final String? ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = context.metro;
    final id = ticketId;
    final kg = id == null ? null : ref.watch(bookedTripKgProvider(id)).value;
    final per10km = greenNumber(TravelMode.motorbike.savedKg(10));
    final summary = ref.watch(greenSummaryProvider).value;
    final to = summary?.tier.toKg;
    return MetroCard(
      onTap: () => context.push(Routes.pGreen),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.leaf, color: m.success),
          MetroSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.greenTitle, style: context.text.titleSmall),
                MetroSpacing.gapXxs,
                Text(
                  kg != null
                      ? l.greenBookedTrip(greenNumber(kg))
                      : id != null
                      ? l.greenBookedPass(per10km)
                      : l.greenBookedParking(per10km),
                  style: context.text.bodyMedium,
                ),
                if (summary != null && to != null) ...[
                  MetroSpacing.gapXxs,
                  Text(
                    l.greenNextTier(
                      greenTierLabel(l, summary.tier),
                      greenNumber(to - summary.savedKg),
                    ),
                    style: context.text.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
