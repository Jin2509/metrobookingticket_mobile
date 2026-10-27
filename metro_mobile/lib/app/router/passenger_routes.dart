import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/booking_routes.dart';
import 'package:metro_mobile/app/router/explore_routes.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/app/router/wallet_routes.dart';
import 'package:metro_mobile/app/shells/passenger_shell.dart';
import 'package:metro_mobile/features/chatbot/presentation/screens/chat_screen.dart';
import 'package:metro_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:metro_mobile/features/notifications/presentation/screens/news_detail_screen.dart';

/// `/p/*`: Passenger shell 4 tab (giữ state từng tab) + các màn toàn màn
/// hình (Trợ lý, đặt vé, thanh toán...).
final passengerRoutes = <RouteBase>[
  StatefulShellRoute.indexedStack(
    builder: (_, state, shell) =>
        PassengerShell(shell: shell, location: state.uri.path),
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(path: Routes.pHome, builder: (_, _) => const HomeScreen()),
        ],
      ),
      StatefulShellBranch(routes: [exploreRoute]),
      StatefulShellBranch(routes: [ticketsRoute]),
      StatefulShellBranch(routes: [accountRoute]),
    ],
  ),
  // Trợ lý mở bằng nút nổi (sheet); route này cho deep link.
  GoRoute(path: Routes.pAssistant, builder: (_, _) => const ChatScreen()),
  GoRoute(
    path: '/p/news/:id',
    builder: (_, s) => NewsDetailScreen(newsId: s.pathParameters['id']!),
  ),
  ...bookingRoutes,
];
