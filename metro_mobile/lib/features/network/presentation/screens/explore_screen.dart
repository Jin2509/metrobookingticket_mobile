import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/explore_quick_actions.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/explore_search_bar.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/lines_section.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P20. Tab Khám phá: tìm ga, lối tắt, danh sách tuyến.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navExplore)),
      body: RefreshIndicator(
        onRefresh: () => refreshCatalog(ref),
        child: ListView(
          padding: const EdgeInsets.all(MetroSpacing.md),
          children: [
            const ExploreSearchBar(),
            MetroSpacing.gapMd,
            const ExploreQuickActions(),
            MetroSpacing.gapLg,
            Text(context.l10n.metroLines, style: context.text.titleMedium),
            MetroSpacing.gapSm,
            const LinesSection(),
          ],
        ),
      ),
    );
  }
}
