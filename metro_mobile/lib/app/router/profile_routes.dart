import 'package:go_router/go_router.dart';
import 'package:metro_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:metro_mobile/features/profile/presentation/screens/verify_new_email_screen.dart';

/// Hồ sơ (P51 / S40), route con của tab Tài khoản ở cả 2 shell.
GoRoute profileRoute(String profilePath) => GoRoute(
  path: 'profile',
  builder: (_, _) => ProfileScreen(profilePath: profilePath),
  routes: [
    GoRoute(
      path: 'verify-email',
      builder: (_, s) =>
          VerifyNewEmailScreen(email: s.uri.queryParameters['email'] ?? ''),
    ),
  ],
);
