import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/explore_quick_actions.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/explore_search_bar.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/lines_section.dart';
import 'package:metro_mobile/features/network/presentation/widgets/network3d/network_3d_preview_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P20. Tab Khám phá: tìm ga, sơ đồ 3D, lối tắt, danh sách tuyến.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => refreshCatalog(ref),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              MetroSpacing.md,
              MetroSpacing.md,
              MetroSpacing.md,
              MetroSpacing.fabClearance,
            ),
            children: [
              Text(l.navExplore, style: context.text.displaySmall),
              MetroSpacing.gapMd,
              const ExploreSearchBar(),
              MetroSpacing.gapMd,
              const Network3dPreviewCard(),
              MetroSpacing.gapLg,
              const ExploreQuickActions(),
              MetroSpacing.gapLg,
              Text(l.metroLines, style: context.text.titleLarge),
              MetroSpacing.gapSm,
              const LinesSection(),
            ],
          ),
        ),
      ),
    );
  }
}
