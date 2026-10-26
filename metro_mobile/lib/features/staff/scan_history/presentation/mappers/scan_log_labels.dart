import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';
import 'package:metro_mobile/l10n/l10n.dart';

String scanLogFilterLabel(AppLocalizations l, ScanLogFilter f) => switch (f) {
  ScanLogFilter.all => l.all,
  ScanLogFilter.tickets => l.filterTickets,
  ScanLogFilter.parking => l.navParking,
  ScanLogFilter.rejected => l.filterRejected,
};
