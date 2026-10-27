import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// 4 tab Passenger (Trợ lý là nút nổi), thứ tự khớp branch trong
/// `passenger_routes.dart`.
List<MetroNavItem> passengerNavItems(AppLocalizations l) => [
  MetroNavItem(icon: LucideIcons.house, label: l.navHome),
  MetroNavItem(icon: LucideIcons.map, label: l.navExplore),
  MetroNavItem(icon: LucideIcons.ticket, label: l.navTickets),
  MetroNavItem(icon: LucideIcons.circleUser, label: l.navAccount),
];
