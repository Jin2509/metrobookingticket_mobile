import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/app/router/navigator_keys.dart';
import 'package:metro_mobile/app/settings/app_settings.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/l10n/gen/app_localizations.dart';

class MetroApp extends ConsumerWidget {
  const MetroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theme theo vai trò (mục 6.2): Passenger light/dark theo cài đặt,
    // Staff và vai trò khác luôn dùng theme staff.
    final role = ref.watch(authControllerProvider.select((s) => s.value?.role));
    final settings =
        ref.watch(appSettingsProvider).value ?? const AppSettings();
    final isPassenger = role == null || role == Role.passenger;
    // Luke chào ngay khi đăng nhập xong. Khôi phục phiên lúc mở app không tính vì
    // trạng thái trước đó còn đang tải.
    ref.listen(authControllerProvider, (prev, next) {
      final user = next.value;
      if (user == null || prev == null || prev.isLoading) return;
      if (prev.value != null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = rootNavigatorKey.currentContext;
        if (ctx == null || !ctx.mounted) return;
        final l = AppLocalizations.of(ctx);
        MascotBoard.show(
          ctx,
          title: l.lukeLoginTitle(user.name.split(' ').last),
          message: l.lukeLoginBody,
          mood: MascotMood.happy,
        );
      });
    });
    return MaterialApp.router(
      title: 'Metro TP.HCM',
      debugShowCheckedModeBanner: Env.isDev,
      theme: isPassenger ? MetroTheme.light : MetroTheme.staff,
      darkTheme: isPassenger ? MetroTheme.dark : MetroTheme.staff,
      themeMode: isPassenger ? settings.themeMode : ThemeMode.dark,
      routerConfig: ref.watch(appRouterProvider),
      scrollBehavior: const MetroScrollBehavior(),
      locale: settings.locale ?? const Locale('vi'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
