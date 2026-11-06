import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/incident/presentation/controllers/incident_providers.dart';
import 'package:metro_mobile/features/staff/incident/presentation/widgets/incident_tile.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Sự cố tại ga đang phân công: việc đang mở xem trước, nút báo luôn trong tầm.
class IncidentListScreen extends ConsumerStatefulWidget {
  const IncidentListScreen({super.key});

  @override
  ConsumerState<IncidentListScreen> createState() => _State();
}

class _State extends ConsumerState<IncidentListScreen> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.incidentListTitle)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'report-incident',
        icon: const Icon(LucideIcons.plus),
        label: Text(l.incidentReport),
        onPressed: () => context.push(Routes.sIncidentNew),
      ),
      body: Column(
        children: [
          Padding(
            padding: MetroSpacing.screenPadding,
            child: Row(
              children: [
                ChoiceChip(
                  label: Text(l.incidentTabOpen),
                  showCheckmark: false,
                  selected: _open,
                  onSelected: (_) => setState(() => _open = true),
                ),
                MetroSpacing.gapXs,
                ChoiceChip(
                  label: Text(l.incidentStatusResolved),
                  showCheckmark: false,
                  selected: !_open,
                  onSelected: (_) => setState(() => _open = false),
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncValueView(
              value: ref.watch(incidentsProvider),
              onRetry: () => ref.invalidate(incidentsProvider),
              data: (all) {
                final list = all.where((e) => e.isOpen == _open).toList();
                return list.isEmpty
                    ? EmptyState(
                        icon: LucideIcons.circleCheck,
                        title: l.incidentEmpty,
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                          MetroSpacing.md,
                          MetroSpacing.sm,
                          MetroSpacing.md,
                          MetroSpacing.fabClearance,
                        ),
                        children: [
                          for (final e in list) IncidentTile(incident: e),
                        ],
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
