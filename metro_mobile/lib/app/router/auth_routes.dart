import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:metro_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:metro_mobile/features/auth/presentation/screens/otp_screen.dart';
import 'package:metro_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:metro_mobile/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:metro_mobile/features/auth/presentation/screens/two_factor_screen.dart';

/// `/auth/*` dùng chung 2 vai trò.
final authRoutes = <RouteBase>[
  GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
  GoRoute(path: Routes.register, builder: (_, _) => const RegisterScreen()),
  GoRoute(
    path: Routes.otp,
    builder: (_, s) {
      final expires = int.tryParse(s.uri.queryParameters['expires'] ?? '');
      return OtpScreen(
        email: s.uri.queryParameters['email'] ?? '',
        expiresIn: expires == null ? null : Duration(seconds: expires),
      );
    },
  ),
  GoRoute(
    path: Routes.twoFactor,
    // Ticket chỉ truyền qua `extra`, không nằm trên URL. Mất `extra` thì đăng
    // nhập lại.
    redirect: (_, s) => s.extra is TwoFactorLogin ? null : Routes.login,
    builder: (_, s) => TwoFactorScreen(login: s.extra! as TwoFactorLogin),
  ),
  GoRoute(path: Routes.forgot, builder: (_, _) => const ForgotPasswordScreen()),
  GoRoute(
    path: Routes.reset,
    builder: (_, s) =>
        ResetPasswordScreen(email: s.uri.queryParameters['email']),
  ),
];
