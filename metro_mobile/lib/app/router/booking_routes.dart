import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';
import 'package:metro_mobile/features/booking/presentation/screens/booking_confirm_screen.dart';
import 'package:metro_mobile/features/booking/presentation/screens/fare_table_screen.dart';
import 'package:metro_mobile/features/booking/presentation/screens/payment_qr_screen.dart';
import 'package:metro_mobile/features/booking/presentation/screens/payment_result_screen.dart';
import 'package:metro_mobile/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:metro_mobile/features/parking/presentation/screens/parking_booking_screen.dart';

/// Màn toàn màn hình ngoài tab: đặt vé + thanh toán (P30–P34),
/// gửi xe (P35), hộp thông báo (P60).
final bookingRoutes = <RouteBase>[
  GoRoute(
    path: Routes.book,
    builder: (_, s) {
      final q = s.uri.queryParameters;
      return BookingConfirmScreen(
        request: BookingRequest(
          typeCode: q['type'] ?? 'SINGLE',
          fromId: q['from'],
          toId: q['to'],
        ),
      );
    },
    routes: [
      GoRoute(
        path: 'payment/:orderId',
        builder: (_, s) =>
            PaymentQrScreen(orderId: s.pathParameters['orderId']!),
      ),
      GoRoute(
        path: 'result',
        builder: (_, s) {
          final q = s.uri.queryParameters;
          return PaymentResultScreen(
            status: PaymentStatus.values.firstWhere(
              (e) => e.name == q['status'],
              orElse: () => PaymentStatus.failed,
            ),
            ticketId: q['ticket'],
            parkingId: q['parking'],
            refundCode: q['refund'],
          );
        },
      ),
    ],
  ),
  GoRoute(path: Routes.fares, builder: (_, _) => const FareTableScreen()),
  GoRoute(
    path: Routes.pParkingBook,
    builder: (_, _) => const ParkingBookingScreen(),
  ),
  GoRoute(
    path: Routes.pNotifications,
    builder: (_, _) => const NotificationsScreen(),
  ),
];
