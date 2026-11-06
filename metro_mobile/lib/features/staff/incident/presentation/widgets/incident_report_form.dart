import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';
import 'package:metro_mobile/features/staff/incident/presentation/controllers/incident_form_controller.dart';
import 'package:metro_mobile/features/staff/incident/presentation/controllers/incident_providers.dart';
import 'package:metro_mobile/features/staff/incident/presentation/widgets/incident_choice_group.dart';
import 'package:metro_mobile/features/staff/incident/presentation/widgets/incident_labels.dart';
import 'package:metro_mobile/features/staff/incident/presentation/widgets/incident_photos_field.dart';
import 'package:metro_mobile/features/staff/shift/presentation/widgets/shift_header.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Nội dung báo sự cố: chọn nhanh loại, vị trí, mức độ; các phần còn lại không
/// bắt buộc, trừ mô tả khi chọn "Khác".
class IncidentReportForm extends ConsumerWidget {
  const IncidentReportForm({super.key});

  Future<void> _send(BuildContext context, WidgetRef ref) async {
    final say = MascotToast.of(context);
    final message = context.l10n.incidentSent;
    final sent = await ref.read(incidentFormProvider.notifier).submit();
    if (sent && context.mounted) {
      say(message);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = context.metro;
    final s = ref.watch(incidentFormProvider);
    final ctrl = ref.read(incidentFormProvider.notifier);
    final duplicate = s.type == null
        ? null
        : ref
              .watch(incidentsProvider)
              .value
              ?.where((e) => e.isOpen && e.type == s.type)
              .firstOrNull;
    final error = s.pickFailed ? l.studentPickFailed : s.error;
    return ListView(
      padding: const EdgeInsets.all(MetroSpacing.md),
      children: [
        const ShiftHeader(showActions: false),
        MetroSpacing.gapMd,
        IncidentChoiceGroup<IncidentType>(
          title: l.incidentFieldType,
          values: IncidentType.values,
          selected: s.type,
          labelOf: (v) => incidentTypeLabel(l, v),
          iconOf: incidentTypeIcon,
          onSelected: ctrl.setType,
        ),
        if (duplicate != null) ...[
          MetroSpacing.gapXs,
          Text(
            l.incidentDuplicate(duplicate.id),
            style: context.text.bodySmall?.copyWith(color: m.accent),
          ),
        ],
        MetroSpacing.gapMd,
        IncidentChoiceGroup<IncidentLocation>(
          title: l.incidentFieldLocation,
          values: IncidentLocation.values,
          selected: s.location,
          labelOf: (v) => incidentLocationLabel(l, v),
          onSelected: ctrl.setLocation,
        ),
        MetroSpacing.gapMd,
        IncidentChoiceGroup<IncidentSeverity>(
          title: l.incidentFieldSeverity,
          values: IncidentSeverity.values,
          selected: s.severity,
          labelOf: (v) => incidentSeverityLabel(l, v),
          onSelected: ctrl.setSeverity,
        ),
        if (s.severity == IncidentSeverity.emergency) ...[
          MetroSpacing.gapXs,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.siren, size: 18, color: m.destructive),
              MetroSpacing.gapXs,
              Expanded(
                child: Text(
                  l.incidentEmergencyNote,
                  style: context.text.bodySmall?.copyWith(color: m.destructive),
                ),
              ),
            ],
          ),
        ],
        MetroSpacing.gapMd,
        TextField(
          maxLines: 3,
          maxLength: IncidentFormState.maxDescription,
          onChanged: ctrl.setDescription,
          decoration: InputDecoration(
            labelText: s.type == IncidentType.other
                ? l.incidentFieldDescriptionRequired
                : l.incidentFieldDescription,
          ),
        ),
        MetroSpacing.gapXs,
        const IncidentPhotosField(),
        MetroSpacing.gapXs,
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: s.propose,
          title: Text(l.incidentPropose, style: context.text.titleSmall),
          subtitle: Text(l.incidentProposeHint, style: context.text.bodySmall),
          onChanged: (v) => ctrl.setPropose(value: v),
        ),
        if (error != null) ...[
          Text(
            error,
            style: context.text.bodySmall?.copyWith(color: m.destructive),
          ),
          MetroSpacing.gapXs,
        ],
        MetroSpacing.gapXs,
        MetroButton(
          label: l.incidentSend,
          expand: true,
          size: MetroButtonSize.lg,
          loading: s.submitting,
          onPressed: s.canSubmit ? () => _send(context, ref) : null,
        ),
      ],
    );
  }
}
