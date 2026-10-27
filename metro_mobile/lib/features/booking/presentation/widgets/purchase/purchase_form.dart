import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/ticket_type.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/purchase_controller.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/purchase/booking_steps.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/purchase/purchase_stations.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/purchase/ticket_type_option.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nội dung P29: bước 1/3, danh sách loại vé, hành trình (vé lượt).
class PurchaseForm extends ConsumerWidget {
  const PurchaseForm({
    required this.initial,
    required this.table,
    required this.plan,
    super.key,
  });

  final BookingRequest initial;
  final FareTable table;
  final RoutePlan? plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final r = ref.watch(purchaseProvider(initial));
    final ctrl = ref.read(purchaseProvider(initial).notifier);
    final type = table.types.where((t) => t.code == r.typeCode).firstOrNull;
    final minFare = table.singleTiers.isEmpty
        ? null
        : table.singleTiers.map((t) => t.price).reduce((a, b) => a < b ? a : b);
    final p = plan;
    return ListView(
      padding: const EdgeInsets.all(MetroSpacing.md),
      children: [
        const BookingSteps(current: 0),
        MetroSpacing.gapLg,
        Text(l.ticketTypeTitle, style: context.text.titleMedium),
        MetroSpacing.gapSm,
        for (final t in table.types) ...[
          TicketTypeOption(
            type: t,
            selected: t.code == r.typeCode,
            minSingleFare: minFare,
            onTap: () => ctrl.setType(t.code),
          ),
          MetroSpacing.gapXs,
        ],
        if (type?.needsStations ?? false) ...[
          MetroSpacing.gapMd,
          Text(l.journeyTitle, style: context.text.titleMedium),
          MetroSpacing.gapSm,
          PurchaseStations(initial: initial),
          MetroSpacing.gapSm,
          if (p != null)
            RouteSummaryBar(
              fare: p.fare,
              minutes: p.minutes,
              stationCount: p.stationCount,
              transfers: p.transfers,
            )
          else
            Text(l.chooseDifferentStations, style: context.text.bodySmall),
        ],
      ],
    );
  }
}
