import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/incident/presentation/controllers/incident_providers.dart';
import 'package:metro_mobile/features/staff/incident/presentation/widgets/incident_detail_body.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Chi tiết một sự cố và nút đổi trạng thái.
class IncidentDetailScreen extends ConsumerWidget {
  const IncidentDetailScreen({required this.incidentId, super.key});

  final String incidentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.incidentDetailTitle)),
      body: AsyncValueView(
        value: ref.watch(incidentsProvider),
        onRetry: () => ref.invalidate(incidentsProvider),
        data: (all) {
          final e = all.where((i) => i.id == incidentId).firstOrNull;
          return e == null
              ? EmptyState(icon: LucideIcons.searchX, title: l.incidentNotFound)
              : IncidentDetailBody(incident: e);
        },
      ),
    );
  }
}
