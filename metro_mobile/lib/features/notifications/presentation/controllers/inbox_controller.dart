import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';
import 'package:metro_mobile/features/notifications/notification_providers.dart';

/// Hộp thư của người đang đăng nhập; nghe thông báo mới qua WS để badge
/// chuông cập nhật realtime. Đổi người dùng thì tải lại từ đầu.
final inboxProvider =
    AsyncNotifierProvider<InboxController, List<AppNotification>>(
      InboxController.new,
    );

/// Số thông báo chưa đọc cho badge chuông.
final unreadCountProvider = Provider<int>(
  (ref) => ref.watch(inboxProvider).value?.where((n) => !n.read).length ?? 0,
);

class InboxController extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    final userId = ref.watch(authControllerProvider.select((s) => s.value?.id));
    if (userId == null) return const [];
    final inbox = ref.read(manageInboxProvider);
    final sub = inbox.incoming().listen((n) {
      final cur = state.value ?? const <AppNotification>[];
      state = AsyncData([n, ...cur.where((e) => e.id != n.id)]);
    });
    ref.onDispose(() => unawaited(sub.cancel()));
    unawaited(_registerDevice());
    return await inbox.load();
  }

  Future<void> _registerDevice() async {
    final token = await ref.read(pushServiceProvider).deviceToken();
    if (token != null) {
      await ref.read(notificationRepositoryProvider).registerDeviceToken(token);
    }
  }

  Future<void> markRead(String id) async {
    final cur = state.value ?? const <AppNotification>[];
    state = AsyncData([
      for (final n in cur)
        if (n.id == id) n.asRead() else n,
    ]);
    await ref.read(manageInboxProvider).markRead(id);
  }

  Future<void> markAllRead() async {
    final cur = state.value ?? const <AppNotification>[];
    state = AsyncData([for (final n in cur) n.asRead()]);
    await ref.read(manageInboxProvider).markAllRead();
  }
}
