import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/home/presentation/widgets/member_chip.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/inbox_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Xin chào, Minh Anh 👋        🔔`
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(authControllerProvider).value?.name ?? '';
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.greeting, style: context.text.bodyMedium),
              Text(name, style: context.text.titleLarge),
              const MemberChip(),
            ],
          ),
        ),
        MetroIconButton(
          icon: LucideIcons.bell,
          tooltip: context.l10n.notifications,
          badgeCount: ref.watch(unreadCountProvider),
          onPressed: () => context.push(Routes.pNotifications),
        ),
      ],
    );
  }
}
