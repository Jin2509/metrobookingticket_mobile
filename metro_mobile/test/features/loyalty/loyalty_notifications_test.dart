import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/loyalty/data/sources/loyalty_fake_source.dart';
import 'package:metro_mobile/features/loyalty/domain/usecases/loyalty_usecases.dart';
import 'package:metro_mobile/features/notifications/data/sources/notification_fake_source.dart';
import 'package:metro_mobile/features/notifications/domain/entities/notification_entities.dart';
import 'package:metro_mobile/features/notifications/domain/usecases/notification_usecases.dart';
import 'package:metro_mobile/features/notifications/notification_providers.dart';
import 'package:metro_mobile/features/notifications/presentation/controllers/inbox_controller.dart';

class _SignedIn extends AuthController {
  @override
  Future<SessionUser?> build() async => const SessionUser(
    id: 'u-passenger',
    name: 'Minh Anh',
    email: 'passenger@metro.vn',
    role: Role.passenger,
  );
}

void main() {
  test('hạng thành viên: 820 điểm = Bạc, còn 1.180 lên Vàng', () {
    final t = tierOf(820);
    expect(t.tier, 'Bạc');
    expect(t.next, 'Vàng');
    expect(t.toNext, 1180);
    expect(t.progress, closeTo(320 / 1500, 1e-9));
    expect(tierOf(6000).next, isNull);
    expect(tierOf(0).tier, 'Đồng');
  });

  test('ưu đãi chỉ còn hạn, sắp hết hạn lên trước', () async {
    final list = await GetPromotions(
      LoyaltyFakeSource(DemoLedger(), latency: Duration.zero),
    )();
    expect(list.map((p) => p.title), ['SV Tháng 11', 'Gửi xe cuối tuần']);
  });

  test('UC13-03 A1: không cho tắt thông báo bắt buộc', () async {
    final update = UpdateNotificationPrefs(
      NotificationFakeSource(DemoLedger(), latency: Duration.zero),
    );
    expect(
      () => update(const NotificationPrefs(operation: false)),
      throwsA(isA<ValidationFailure>()),
    );
    expect(
      () => update(const NotificationPrefs(payment: false)),
      throwsA(isA<ValidationFailure>()),
    );
    final saved = await update(const NotificationPrefs(promotion: false));
    expect(saved.promotion, isFalse);
  });

  test('badge chuông cập nhật realtime khi có thông báo mới', () async {
    final ledger = DemoLedger();
    final c = ProviderContainer(
      overrides: [
        demoLedgerProvider.overrideWithValue(ledger),
        authControllerProvider.overrideWith(_SignedIn.new),
        notificationRepositoryProvider.overrideWithValue(
          NotificationFakeSource(ledger, latency: Duration.zero),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(unreadCountProvider, (_, _) {});
    await c.read(authControllerProvider.future);
    await c.read(inboxProvider.future);
    expect(c.read(unreadCountProvider), 1);

    ledger.notify('PAYMENT', 'Thanh toán thành công');
    await Future<void>.delayed(Duration.zero);
    expect(c.read(unreadCountProvider), 2);
    expect(c.read(inboxProvider).value!.first.title, 'Thanh toán thành công');

    await c.read(inboxProvider.notifier).markAllRead();
    expect(c.read(unreadCountProvider), 0);
    unawaited(Future<void>.value());
  });
}
