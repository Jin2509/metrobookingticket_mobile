import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/incident/domain/entities/station_incident.dart';
import 'package:metro_mobile/l10n/l10n.dart';

String incidentTypeLabel(AppLocalizations l, IncidentType t) => switch (t) {
  IncidentType.gate => l.incidentTypeGate,
  IncidentType.lift => l.incidentTypeLift,
  IncidentType.equipment => l.incidentTypeEquipment,
  IncidentType.hygiene => l.incidentTypeHygiene,
  IncidentType.security => l.incidentTypeSecurity,
  IncidentType.medical => l.incidentTypeMedical,
  IncidentType.parking => l.incidentTypeParking,
  IncidentType.other => l.incidentTypeOther,
};

IconData incidentTypeIcon(IncidentType t) => switch (t) {
  IncidentType.gate => LucideIcons.doorOpen,
  IncidentType.lift => LucideIcons.arrowUpDown,
  IncidentType.equipment => LucideIcons.wrench,
  IncidentType.hygiene => LucideIcons.droplets,
  IncidentType.security => LucideIcons.shieldAlert,
  IncidentType.medical => LucideIcons.heartPulse,
  IncidentType.parking => LucideIcons.circleParking,
  IncidentType.other => LucideIcons.ellipsis,
};

String incidentLocationLabel(AppLocalizations l, IncidentLocation v) =>
    switch (v) {
      IncidentLocation.entryGate => l.incidentLocEntry,
      IncidentLocation.exitGate => l.incidentLocExit,
      IncidentLocation.concourse => l.incidentLocConcourse,
      IncidentLocation.platform => l.incidentLocPlatform,
      IncidentLocation.parking => l.incidentLocParking,
      IncidentLocation.other => l.incidentLocOther,
    };

String incidentSeverityLabel(AppLocalizations l, IncidentSeverity v) =>
    switch (v) {
      IncidentSeverity.minor => l.incidentSevMinor,
      IncidentSeverity.operations => l.incidentSevOperations,
      IncidentSeverity.emergency => l.incidentSevEmergency,
    };

Color incidentSeverityColor(BuildContext context, IncidentSeverity v) =>
    switch (v) {
      IncidentSeverity.minor => context.metro.mutedForeground,
      IncidentSeverity.operations => context.metro.accent,
      IncidentSeverity.emergency => context.metro.destructive,
    };

String incidentStatusLabel(AppLocalizations l, IncidentStatus v) => switch (v) {
  IncidentStatus.open => l.incidentStatusOpen,
  IncidentStatus.inProgress => l.incidentStatusProgress,
  IncidentStatus.resolved => l.incidentStatusResolved,
};

Color incidentStatusColor(BuildContext context, IncidentStatus v) =>
    switch (v) {
      IncidentStatus.open => context.metro.destructive,
      IncidentStatus.inProgress => context.metro.accent,
      IncidentStatus.resolved => context.metro.success,
    };

String? incidentPublicationLabel(AppLocalizations l, IncidentPublication v) =>
    switch (v) {
      IncidentPublication.none => null,
      IncidentPublication.pending => l.incidentPublishPending,
      IncidentPublication.published => l.incidentPublished,
    };
