import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/core/platform/push_service.dart';
import 'package:metro_mobile/features/notifications/data/sources/notification_fake_source.dart';
import 'package:metro_mobile/features/notifications/data/sources/notification_remote_source.dart';
import 'package:metro_mobile/features/notifications/domain/repositories/notification_repository.dart';
import 'package:metro_mobile/features/notifications/domain/usecases/notification_usecases.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => Env.useFakeData
      ? NotificationFakeSource(ref.watch(demoLedgerProvider))
      : NotificationRemoteSource(
          ref.watch(dioProvider),
          ref.watch(stompClientProvider),
        ),
);

final manageInboxProvider = Provider(
  (ref) => ManageInbox(ref.watch(notificationRepositoryProvider)),
);
final getNewsProvider = Provider(
  (ref) => GetNews(ref.watch(notificationRepositoryProvider)),
);
final updatePrefsProvider = Provider(
  (ref) => UpdateNotificationPrefs(ref.watch(notificationRepositoryProvider)),
);

final pushServiceProvider = Provider<PushService>(
  (_) => const NoopPushService(),
);
