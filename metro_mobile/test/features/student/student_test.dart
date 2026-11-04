import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/features/student/data/sources/student_fake_source.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';

void main() {
  final image = Uint8List(1);

  StudentFakeSource source(DemoLedger ledger) => StudentFakeSource(
    ledger,
    latency: Duration.zero,
    reviewDelay: Duration.zero,
  );

  test('chưa gửi thẻ thì chưa có ưu đãi', () async {
    final ledger = DemoLedger();
    expect((await source(ledger).getMine()).status, StudentStatus.none);
    expect(ledger.studentVerified, isFalse);
  });

  test('gửi thẻ là chờ duyệt, được duyệt có hiệu lực 1 năm', () async {
    final ledger = DemoLedger();
    final s = source(ledger);
    expect((await s.submitCard(image)).status, StudentStatus.pending);
    final r = await s.getMine();
    final now = ledger.clock();
    expect(r.status, StudentStatus.verified);
    expect(r.daysLeft(now), inInclusiveRange(364, 365));
    expect(r.expiringSoon(now), isFalse);
    expect(ledger.studentVerified, isTrue);
    expect(ledger.notifications.first['title'], 'Đã xác nhận sinh viên');
  });

  test('còn dưới 30 ngày thì nhắc xác nhận lại', () async {
    final ledger = DemoLedger()..studentDemoOutcome = 'EXPIRING';
    final s = source(ledger);
    await s.submitCard(image);
    final r = await s.getMine();
    expect(r.expiringSoon(ledger.clock()), isTrue);
    expect(ledger.studentVerified, isTrue);
  });

  test('hết hạn hoặc bị từ chối thì mất ưu đãi và có lý do', () async {
    for (final (code, status) in [
      ('EXPIRED', StudentStatus.expired),
      ('REJECTED', StudentStatus.rejected),
    ]) {
      final ledger = DemoLedger()..studentDemoOutcome = code;
      final s = source(ledger);
      await s.submitCard(image);
      final r = await s.getMine();
      expect(r.status, status);
      expect(r.reason, isNotNull);
      expect(ledger.studentVerified, isFalse);
    }
  });

  test('đang chờ duyệt lần gia hạn vẫn giữ ưu đãi cũ', () {
    final ledger = DemoLedger();
    final until = ledger.clock().add(const Duration(days: 20));
    ledger.studentRecord = {
      'status': 'PENDING',
      'expiresAt': until.toIso8601String(),
    };
    final r = StudentVerification.fromJson(ledger.studentRecord!);
    expect(r.isActive(ledger.clock()), isTrue);
    expect(ledger.studentVerified, isTrue);
  });
}
