import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/l10n/l10n.dart';

String ticketFilterLabel(AppLocalizations l, TicketFilter f) => switch (f) {
  TicketFilter.all => l.all,
  TicketFilter.unused => l.filterUnused,
  TicketFilter.inUse => l.filterInUse,
  TicketFilter.expired => l.statusExpired,
};
