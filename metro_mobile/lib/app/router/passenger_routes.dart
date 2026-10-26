import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/booking_routes.dart';
import 'package:metro_mobile/app/router/explore_routes.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/app/router/wallet_routes.dart';
import 'package:metro_mobile/app/shells/passenger_shell.dart';
import 'package:metro_mobile/features/chatbot/presentation/screens/chat_screen.dart';
import 'package:metro_mobile/features/home/presentation/screens/home_screen.dart';

/// `/p/*`: Passenger shell 5 tab (giữ state từng tab) + màn đặt vé
/// toàn màn hình.
final passengerRoutes = <RouteBase>[
  StatefulShellRoute.indexedStack(
    builder: (_, _, shell) => PassengerShell(shell: shell),
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(path: Routes.pHome, builder: (_, _) => const HomeScreen()),
        ],
      ),
      StatefulShellBranch(routes: [exploreRoute]),
      StatefulShellBranch(routes: [ticketsRoute]),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.pAssistant,
            builder: (_, _) => const ChatScreen(),
          ),
        ],
      ),
      StatefulShellBranch(routes: [accountRoute]),
    ],
  ),
  ...bookingRoutes,
];
