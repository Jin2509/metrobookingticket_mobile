import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/booking_controllers.dart';
import 'package:metro_mobile/features/home/presentation/controllers/quick_book_controller.dart';
import 'package:metro_mobile/features/home/presentation/widgets/quick_book_stations.dart';
import 'package:metro_mobile/features/home/presentation/widgets/ticket_type_chips.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// ĐẶT VÉ NHANH (P10): chọn ga, loại vé, giá, [Thanh toán] → P30.
/// Vé ngày/tháng bỏ qua bước chọn ga (mục 7.2).
class QuickBookCard extends ConsumerWidget {
  const QuickBookCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(quickBookProvider);
    final types = ref.watch(fareTableProvider).value?.types ?? const [];
    final type = types.where((t) => t.code == s.typeCode).firstOrNull;
    final needsStations = type?.needsStations ?? true;
    final plan = needsStations
        ? ref.watch(quickRouteProvider((s.fromId, s.toId))).value
        : null;
    final ready = !needsStations || plan != null;
    return SectionCard(
      title: context.l10n.quickBook,
      actionLabel: context.l10n.fares,
      onAction: () => context.push(Routes.fares),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (needsStations) ...[const QuickBookStations(), MetroSpacing.gapSm],
          const TicketTypeChips(),
          MetroSpacing.gapSm,
          if (plan != null)
            RouteSummaryBar(
              fare: plan.fare,
              minutes: plan.minutes,
              stationCount: plan.stationCount,
              transfers: plan.transfers,
            )
          else if (!needsStations && type != null)
            Text(
              '${type.name} · ${type.validity}',
              style: context.text.bodyMedium,
            ),
          MetroSpacing.gapSm,
          MetroButton(
            label: context.l10n.pay,
            expand: true,
            onPressed: ready
                ? () => context.push(
                    Routes.bookWith(
                      s.typeCode,
                      from: needsStations ? s.fromId : null,
                      to: needsStations ? s.toId : null,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
