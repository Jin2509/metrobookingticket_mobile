import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/l10n/l10n.dart';

String scanModeLabel(AppLocalizations l, ScanMode m) => switch (m) {
  ScanMode.entry => l.scanEntry,
  ScanMode.exit => l.scanExit,
};

String rejectReasonLabel(AppLocalizations l, RejectReason r) => switch (r) {
  RejectReason.expired => l.rejectExpired,
  RejectReason.used => l.rejectUsed,
  RejectReason.alreadyIn => l.rejectAlreadyIn,
  RejectReason.notIn => l.rejectNotIn,
  RejectReason.wrongStation => l.rejectWrongStation,
  RejectReason.notFound => l.rejectNotFound,
  RejectReason.wrongKind => l.errQrWrongKind,
  RejectReason.forbidden => l.rejectForbidden,
};
