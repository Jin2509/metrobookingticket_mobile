import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/features/student/data/sources/student_fake_source.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';

void main() {
  final image = Uint8List(1);

  test('chưa gửi thẻ thì chưa xác thực', () async {
    final source = StudentFakeSource(DemoLedger(), latency: Duration.zero);
    expect((await source.getMine()).status, StudentStatus.none);
  });

  test('đạt thì lưu lại và mở ưu đãi', () async {
    final ledger = DemoLedger();
    final source = StudentFakeSource(ledger, latency: Duration.zero);
    final r = await source.submitCard(image);
    expect(r.isVerified, isTrue);
    expect(r.school, isNotNull);
    expect(ledger.studentVerified, isTrue);
    expect((await source.getMine()).isVerified, isTrue);
  });

  test('chờ kiểm tra hoặc bị từ chối thì chưa mở ưu đãi', () async {
    for (final (code, status) in [
      ('PENDING', StudentStatus.pending),
      ('REJECTED', StudentStatus.rejected),
    ]) {
      final ledger = DemoLedger()..studentDemoOutcome = code;
      final source = StudentFakeSource(ledger, latency: Duration.zero);
      final r = await source.submitCard(image);
      expect(r.status, status);
      expect(r.reason, isNotNull);
      expect(ledger.studentVerified, isFalse);
    }
  });
}
