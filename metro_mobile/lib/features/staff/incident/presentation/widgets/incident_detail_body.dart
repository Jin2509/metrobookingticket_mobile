import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';
import 'package:metro_mobile/features/staff/incident/presentation/controllers/incident_providers.dart';
import 'package:metro_mobile/features/staff/incident/presentation/widgets/incident_labels.dart';
import 'package:metro_mobile/features/staff/incident/presentation/widgets/incident_photo_strip.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thông tin sự cố, ảnh, lịch sử trạng thái. Mọi nhân viên của ga đều đổi được
/// trạng thái và luôn ghi lại người đổi.
class IncidentDetailBody extends ConsumerStatefulWidget {
  const IncidentDetailBody({required this.incident, super.key});

  final StationIncident incident;

  @override
  ConsumerState<IncidentDetailBody> createState() => _State();
}

class _State extends ConsumerState<IncidentDetailBody> {
  bool _busy = false;

  Future<void> _set(IncidentStatus status) async {
    final say = MascotToast.of(context);
    final actor = ref.read(authControllerProvider).value?.name ?? '';
    setState(() => _busy = true);
    try {
      await ref
          .read(incidentRepositoryProvider)
          .updateStatus(widget.incident.id, status, actor);
      ref.invalidate(incidentsProvider);
    } on Failure catch (f) {
      say(f.message, mood: MascotMood.worried);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final e = widget.incident;
    final publication = incidentPublicationLabel(l, e.publication);
    return ListView(
      padding: const EdgeInsets.all(MetroSpacing.md),
      children: [
        MetroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                incidentTypeLabel(l, e.type),
                style: context.text.titleMedium,
              ),
              Text(
                '${l.stationName(e.stationName)} · '
                '${incidentLocationLabel(l, e.location)}',
                style: context.text.bodyMedium,
              ),
              MetroSpacing.gapXs,
              Text(
                '${incidentSeverityLabel(l, e.severity)} · '
                '${incidentStatusLabel(l, e.status)}',
                style: context.text.titleSmall?.copyWith(
                  color: incidentStatusColor(context, e.status),
                ),
              ),
              if (publication != null)
                Text(publication, style: context.text.labelMedium),
              if (e.description.isNotEmpty) ...[
                MetroSpacing.gapXs,
                Text(e.description, style: context.text.bodyMedium),
              ],
            ],
          ),
        ),
        if (e.photoBytes.isNotEmpty || e.photoUrls.isNotEmpty) ...[
          MetroSpacing.gapSm,
          IncidentPhotoStrip(incident: e),
        ],
        MetroSpacing.gapSm,
        SectionCard(
          title: l.incidentHistory,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _line(
                context,
                l.incidentReported(e.reporterName),
                dateTime(e.createdAt),
              ),
              for (final h in e.history)
                _line(
                  context,
                  '${incidentStatusLabel(l, h.status)} · ${h.actorName}',
                  dateTime(h.at),
                ),
            ],
          ),
        ),
        MetroSpacing.gapMd,
        if (e.status == IncidentStatus.open) ...[
          MetroButton(
            label: l.incidentStatusProgress,
            expand: true,
            variant: MetroButtonVariant.outline,
            onPressed: _busy ? null : () => _set(IncidentStatus.inProgress),
          ),
          MetroSpacing.gapXs,
        ],
        if (e.isOpen)
          MetroButton(
            label: l.incidentStatusResolved,
            expand: true,
            loading: _busy,
            onPressed: () => _set(IncidentStatus.resolved),
          ),
      ],
    );
  }

  Widget _line(BuildContext context, String text, String time) => Padding(
    padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xxs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(text, style: context.text.bodyMedium)),
        MetroSpacing.gapXs,
        Text(time, style: context.text.labelSmall),
      ],
    ),
  );
}
