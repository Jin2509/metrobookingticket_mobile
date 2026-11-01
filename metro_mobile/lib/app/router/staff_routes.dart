import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/profile_routes.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/app/shells/staff_shell.dart';
import 'package:metro_mobile/features/profile/presentation/screens/account_screen.dart';
import 'package:metro_mobile/features/staff/parking_control/presentation/screens/parking_control_screen.dart';
import 'package:metro_mobile/features/staff/parking_control/presentation/screens/parking_scan_screen.dart';
import 'package:metro_mobile/features/staff/scan_history/presentation/screens/scan_history_screen.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/screens/ticket_scan_screen.dart';

/// `/s/*`: Staff shell 4 tab, theme tối.
final staffRoutes = <RouteBase>[
  StatefulShellRoute.indexedStack(
    builder: (_, _, shell) => StaffShell(shell: shell),
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.sScan,
            builder: (_, s) => TicketScanScreen(
              initialMode: ScanMode.parse(s.uri.queryParameters['mode']),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.sParking,
            builder: (_, _) => const ParkingControlScreen(),
            routes: [
              GoRoute(
                path: 'scan',
                builder: (_, _) => const ParkingScanScreen(),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.sHistory,
            builder: (_, _) => const ScanHistoryScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.sAccount,
            builder: (_, _) => const AccountScreen(),
            routes: [profileRoute(Routes.sProfile)],
          ),
        ],
      ),
    ],
  ),
];
