import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/home/presentation/widgets/mascot_greeting.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/inbox_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Hàng đầu Trang chủ: Futu, lời chào, cấp CPoint và chuông thông báo.
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: MascotGreeting()),
        MetroIconButton(
          icon: LucideIcons.bell,
          color: MetroColors.primaryForeground,
          tooltip: context.l10n.notifications,
          badgeCount: ref.watch(unreadCountProvider),
          onPressed: () => context.push(Routes.pNotifications),
        ),
      ],
    );
  }
}
