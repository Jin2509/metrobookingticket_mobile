import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/navigator_keys.dart';
import 'package:metro_mobile/app/router/profile_routes.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/features/loyalty/presentation/screens/loyalty_screen.dart';
import 'package:metro_mobile/features/notifications/presentation/screens/news_screen.dart';
import 'package:metro_mobile/features/notifications/presentation/screens/notification_settings_screen.dart';
import 'package:metro_mobile/features/profile/presentation/screens/account_screen.dart';
import 'package:metro_mobile/features/wallet/presentation/screens/my_tickets_screen.dart';
import 'package:metro_mobile/features/wallet/presentation/screens/parking_qr_screen.dart';
import 'package:metro_mobile/features/wallet/presentation/screens/ticket_qr_screen.dart';
import 'package:metro_mobile/features/wallet/presentation/screens/transactions_screen.dart';

/// Tab Vé: P40; QR vé P41 và QR gửi xe P42 toàn màn hình.
final ticketsRoute = GoRoute(
  path: Routes.pTickets,
  builder: (_, _) => const MyTicketsScreen(),
  routes: [
    GoRoute(
      path: 'parking/:bookingId',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, s) =>
          ParkingQrScreen(bookingId: s.pathParameters['bookingId']!),
    ),
    GoRoute(
      path: ':ticketId',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, s) =>
          TicketQrScreen(ticketId: s.pathParameters['ticketId']!),
    ),
  ],
);

/// Tab Tài khoản: P50, P52, P53, P54, P61.
final accountRoute = GoRoute(
  path: Routes.pAccount,
  builder: (_, _) => const AccountScreen(),
  routes: [
    profileRoute(Routes.pProfile),
    GoRoute(
      path: 'transactions',
      builder: (_, _) => const TransactionsScreen(),
    ),
    GoRoute(path: 'loyalty', builder: (_, _) => const LoyaltyScreen()),
    GoRoute(path: 'news', builder: (_, _) => const NewsScreen()),
    GoRoute(
      path: 'notification-settings',
      builder: (_, _) => const NotificationSettingsScreen(),
    ),
  ],
);
