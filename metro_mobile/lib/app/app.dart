import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/app/router/navigator_keys.dart';
import 'package:metro_mobile/app/settings/app_settings.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/inbox_controller.dart';
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
    // Futu chạy qua màn hình ngay khi đăng nhập xong; ai tắt chuyển động thì
    // chỉ hiện bảng chào. Khôi phục phiên lúc mở app không tính vì trạng thái
    // trước đó còn đang tải.
    ref.listen(authControllerProvider, (prev, next) {
      final user = next.value;
      if (user == null || prev == null || prev.isLoading) return;
      if (prev.value != null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = rootNavigatorKey.currentContext;
        if (ctx == null || !ctx.mounted) return;
        final l = AppLocalizations.of(ctx);
        final title = l.futuLoginTitle(user.name.split(' ').last);
        if (MediaQuery.disableAnimationsOf(ctx)) {
          MascotBoard.show(
            ctx,
            title: title,
            message: l.futuLoginBody,
            mood: MascotMood.happy,
          );
        } else {
          MascotRunIntro.show(ctx, title: title, message: l.futuLoginBody);
        }
      });
    });
    // Thông báo mới khi đang dùng app: Futu báo ngay, không chỉ tăng số trên
    // chuông. Thanh toán đã có màn kết quả riêng nên bỏ qua.
    ref.listen(inboxProvider, (prev, next) {
      final before = prev?.value;
      final now = next.value;
      if (before == null || before.isEmpty || now == null || now.isEmpty) {
        return;
      }
      final newest = now.first;
      if (newest.kind == 'PAYMENT' || before.any((n) => n.id == newest.id)) {
        return;
      }
      final ctx = rootNavigatorKey.currentContext;
      if (ctx != null && ctx.mounted) MascotToast.of(ctx)(newest.title);
    });
    return MaterialApp.router(
      title: 'HopOn',
      debugShowCheckedModeBanner: Env.isDev,
      theme: isPassenger ? MetroTheme.light : MetroTheme.staff,
      darkTheme: isPassenger ? MetroTheme.dark : MetroTheme.staff,
      themeMode: isPassenger ? settings.themeMode : ThemeMode.dark,
      routerConfig: ref.watch(appRouterProvider),
      builder: (ctx, child) => MascotOpening(
        title: 'HopOn',
        slogan: AppLocalizations.of(ctx).appSlogan,
        child: child ?? const SizedBox.shrink(),
      ),
      scrollBehavior: const MetroScrollBehavior(),
      locale: settings.locale ?? const Locale('vi'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
