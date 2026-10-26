import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/auth_redirect.dart';
import 'package:metro_mobile/app/router/auth_routes.dart';
import 'package:metro_mobile/app/router/navigator_keys.dart';
import 'package:metro_mobile/app/router/passenger_routes.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/app/router/staff_routes.dart';
import 'package:metro_mobile/app/shells/unsupported_role_screen.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/design_system/gallery/design_system_gallery.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/auth/presentation/screens/splash_screen.dart';

/// Ghép các nhóm route. Redirect chạy lại mỗi khi phiên đổi.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  late final GoRouter router;
  ref.listen(authControllerProvider, (prev, next) {
    final signedOut =
        prev?.value != null && next.hasValue && next.value == null;
    // Đăng xuất: về login sạch, không giữ `from` của người dùng trước.
    signedOut ? router.go(Routes.login) : refresh.value++;
  });

  router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (_, state) =>
        resolveRedirect(ref.read(authControllerProvider), state.uri),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: Routes.unsupported,
        builder: (_, _) => const UnsupportedRoleScreen(),
      ),
      ...authRoutes,
      ...passengerRoutes,
      ...staffRoutes,
      if (Env.isDev)
        GoRoute(
          path: Routes.designGallery,
          builder: (_, _) => const DesignSystemGallery(),
        ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
