import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/controllers/route_search_controller.dart';
import 'package:metro_mobile/features/network/presentation/widgets/route/route_form_card.dart';
import 'package:metro_mobile/features/network/presentation/widgets/route/route_result_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P25/P26. Tra cứu lộ trình giữa hai ga (UC5-03).
class RouteSearchScreen extends ConsumerWidget {
  const RouteSearchScreen({this.from, this.to, super.key});

  final String? from;
  final String? to;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = (from: from, to: to);
    final state = ref.watch(routeSearchProvider(query));
    final catalog = ref.watch(catalogProvider).value;
    final plan = state.plan;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.routeSearchTitle)),
      body: ListView(
        padding: const EdgeInsets.all(MetroSpacing.md),
        children: [
          RouteFormCard(query: query),
          MetroSpacing.gapMd,
          if (state.searching)
            const MetroSkeleton(height: 220, radius: MetroRadius.lg)
          else if (state.notFound)
            EmptyState(
              icon: LucideIcons.route,
              title: context.l10n.routeNotFound,
              message: context.l10n.routeNotFoundBody,
            )
          else if (state.error != null)
            ErrorState(
              message: state.error!,
              onRetry: ref.read(routeSearchProvider(query).notifier).search,
            )
          else if (plan != null && catalog != null)
            RouteResultCard(plan: plan, catalog: catalog),
        ],
      ),
    );
  }
}
