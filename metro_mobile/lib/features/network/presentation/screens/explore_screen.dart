import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/network/presentation/controllers/catalog_providers.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/explore_quick_actions.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/explore_search_bar.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/lines_section.dart';
import 'package:metro_mobile/features/network/presentation/widgets/explore/network_diagram_section.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P20. Tab Khám phá: tìm ga, lối tắt, sơ đồ mạng lưới / danh sách tuyến.
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  var _diagram = true;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.navExplore)),
      body: RefreshIndicator(
        onRefresh: () => refreshCatalog(ref),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            MetroSpacing.md,
            MetroSpacing.md,
            MetroSpacing.md,
            MetroSpacing.fabClearance,
          ),
          children: [
            const ExploreSearchBar(),
            MetroSpacing.gapMd,
            const ExploreQuickActions(),
            MetroSpacing.gapLg,
            SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: true,
                  icon: const Icon(LucideIcons.waypoints),
                  label: Text(l.networkDiagram),
                ),
                ButtonSegment(
                  value: false,
                  icon: const Icon(LucideIcons.list),
                  label: Text(l.metroLines),
                ),
              ],
              selected: {_diagram},
              onSelectionChanged: (s) => setState(() => _diagram = s.first),
            ),
            MetroSpacing.gapMd,
            if (_diagram)
              const NetworkDiagramSection()
            else
              const LinesSection(),
          ],
        ),
      ),
    );
  }
}
