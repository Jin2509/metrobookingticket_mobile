import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';
import 'package:metro_mobile/features/staff/incident/presentation/widgets/incident_labels.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Một sự cố trong danh sách: loại, vị trí, mức độ, trạng thái, giờ, người báo.
class IncidentTile extends StatelessWidget {
  const IncidentTile({required this.incident, super.key});

  final StationIncident incident;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final e = incident;
    final tone = incidentSeverityColor(context, e.severity);
    return Padding(
      padding: const EdgeInsets.only(bottom: MetroSpacing.xs),
      child: MetroCard(
        padding: const EdgeInsets.all(MetroSpacing.sm),
        onTap: () => context.push(Routes.sIncidentDetail(e.id)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: tone.withValues(alpha: .16),
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(
                dimension: 40,
                child: Icon(incidentTypeIcon(e.type), size: 20, color: tone),
              ),
            ),
            MetroSpacing.gapSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${incidentTypeLabel(l, e.type)} · '
                    '${incidentLocationLabel(l, e.location)}',
                    style: context.text.titleSmall,
                  ),
                  Text(
                    incidentSeverityLabel(l, e.severity),
                    style: context.text.bodySmall?.copyWith(color: tone),
                  ),
                  Text(
                    incidentStatusLabel(l, e.status),
                    style: context.text.labelMedium?.copyWith(
                      color: incidentStatusColor(context, e.status),
                    ),
                  ),
                  Text(
                    '${timeOnly(e.createdAt)} · ${e.reporterName}',
                    style: context.text.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
