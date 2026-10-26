import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/inbox_controller.dart';
import 'package:metro_mobile/features/notifications/presentation/widgets/notification_view_mappers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// P60. Hộp thông báo; chạm để đọc và mở màn liên quan.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(inboxProvider.notifier);
    final unread = ref.watch(unreadCountProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notifications),
        actions: [
          TextButton(
            onPressed: unread == 0 ? null : ctrl.markAllRead,
            child: Text(context.l10n.markAllRead),
          ),
        ],
      ),
      body: AsyncValueView(
        value: ref.watch(inboxProvider),
        onRetry: () => ref.invalidate(inboxProvider),
        data: (list) => list.isEmpty
            ? EmptyState(
                icon: LucideIcons.bell,
                title: context.l10n.noNotifications,
              )
            : ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final n = list[i];
                  return NotificationTile(
                    kind: notificationKindOf(n.kind),
                    title: n.title,
                    body: n.body,
                    timeLabel: notificationTime(context.l10n, n.createdAt),
                    unread: !n.read,
                    onTap: () {
                      unawaited(ctrl.markRead(n.id));
                      if (n.link != null) unawaited(context.push(n.link!));
                    },
                  );
                },
              ),
      ),
    );
  }
}
