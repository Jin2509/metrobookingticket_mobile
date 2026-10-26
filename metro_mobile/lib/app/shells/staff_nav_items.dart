import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

/// 4 tab Staff, thứ tự khớp branch trong `staff_routes.dart`.
List<MetroNavItem> staffNavItems(AppLocalizations l) => [
  MetroNavItem(icon: LucideIcons.scanLine, label: l.navScan),
  MetroNavItem(icon: LucideIcons.squareParking, label: l.navParking),
  MetroNavItem(icon: LucideIcons.history, label: l.navHistory),
  MetroNavItem(icon: LucideIcons.circleUser, label: l.navAccount),
];
