import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/domain/entities/network_catalog.dart';
import 'package:metro_mobile/features/network/domain/entities/route_plan.dart';
import 'package:metro_mobile/features/network/presentation/mappers/diagram_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P26: `28 phút · 12 ga · 1 lần chuyển`, giá, sơ đồ rút gọn, hành động.
class RouteResultCard extends StatelessWidget {
  const RouteResultCard({required this.plan, required this.catalog, super.key});

  final RoutePlan plan;
  final NetworkCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final facts = [
      l.minutes(plan.minutes),
      l.stationCount(plan.stationCount),
      if (plan.transfers == 0) l.direct else l.transferCount(plan.transfers),
    ];
    return MetroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(facts.join(' · '), style: context.text.titleMedium),
          MoneyText(
            plan.fare,
            style: context.text.headlineSmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
          MetroSpacing.gapSm,
          LineDiagram(stops: routeDiagramStops(context.l10n, catalog, plan)),
          MetroSpacing.gapSm,
          Row(
            children: [
              Expanded(
                child: MetroButton(
                  label: l.map,
                  icon: LucideIcons.map,
                  variant: MetroButtonVariant.outline,
                  expand: true,
                  onPressed: () =>
                      context.push(Routes.map(stationId: plan.fromId)),
                ),
              ),
              MetroSpacing.gapSm,
              Expanded(
                child: MetroButton(
                  label: l.book,
                  icon: LucideIcons.ticket,
                  expand: true,
                  onPressed: () => context.push(
                    Routes.bookWith('SINGLE', from: plan.fromId, to: plan.toId),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
