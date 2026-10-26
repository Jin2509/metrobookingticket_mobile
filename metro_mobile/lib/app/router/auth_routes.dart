import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:metro_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:metro_mobile/features/auth/presentation/screens/otp_screen.dart';
import 'package:metro_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:metro_mobile/features/auth/presentation/screens/reset_password_screen.dart';

/// `/auth/*` dùng chung 2 vai trò.
final authRoutes = <RouteBase>[
  GoRoute(
    path: Routes.login,
    builder: (_, s) => LoginScreen(from: s.uri.queryParameters['from']),
  ),
  GoRoute(path: Routes.register, builder: (_, _) => const RegisterScreen()),
  GoRoute(
    path: Routes.otp,
    builder: (_, s) => OtpScreen(
      purpose: OtpPurpose.parse(s.uri.queryParameters['purpose']),
      email: s.uri.queryParameters['email'] ?? '',
    ),
  ),
  GoRoute(path: Routes.forgot, builder: (_, _) => const ForgotPasswordScreen()),
  GoRoute(
    path: Routes.reset,
    builder: (_, s) =>
        ResetPasswordScreen(resetToken: s.uri.queryParameters['token']),
  ),
];
