import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/platform/screen_guard_service.dart';
import 'package:metro_mobile/core/qr/metro_qr_codec.dart';
import 'package:metro_mobile/core/qr/qr_payload.dart';
import 'package:metro_mobile/design_system/organisms/qr_pass/screen_guard.dart';
import 'package:metro_mobile/features/wallet/data/sources/wallet_fake_source.dart';
import 'package:metro_mobile/features/wallet/domain/entities/ticket_filter.dart';
import 'package:metro_mobile/features/wallet/domain/usecases/build_pass_qr.dart';
import 'package:metro_mobile/features/wallet/domain/usecases/wallet_usecases.dart';

class _FakeGuard extends ScreenGuardService {
  final calls = <String>[];

  @override
  Future<void> enable() async => calls.add('enable');

  @override
  Future<void> disable() async => calls.add('disable');
}

void main() {
  final repo = WalletFakeSource(DemoLedger(), latency: Duration.zero);

  test('phân trang 20 vé/trang, có trang sau', () async {
    final get = GetMyTickets(repo);
    final p0 = await get(TicketFilter.all);
    expect(p0.items, hasLength(walletPageSize));
    expect(p0.hasMore, isTrue);
    final p1 = await get(TicketFilter.all, page: 1);
    expect(p1.items, hasLength(5));
    expect(p1.hasMore, isFalse);
  });

  test('lọc theo trạng thái', () async {
    final unused = await repo.getMyTickets(TicketFilter.unused, 0, 20);
    expect(unused.items.map((t) => t.status).toSet(), {'PAID'});
    final expired = await repo.getMyTickets(TicketFilter.expired, 0, 50);
    expect(expired.items.every((t) => !t.isUsable), isTrue);
  });

  test('QR vé không chứa thông tin cá nhân', () async {
    final ticket = await repo.getTicket('VE-79990');
    final raw = const BuildPassQr(MetroQrCodec()).ticket(ticket);
    expect(raw, startsWith('MTR1|T|tk_79990m|'));
    for (final pii in [
      'passenger@metro.vn',
      'Minh Anh',
      '@',
      ticket.typeName,
    ]) {
      expect(raw.contains(pii), isFalse, reason: pii);
    }
    final decoded = const MetroQrCodec().decode(raw)!;
    expect(decoded.kind, QrKind.ticket);
    expect(decoded.token, ticket.qrToken);
  });

  test('QR gửi xe dùng loại PARKING', () async {
    final pass = (await repo.getActiveParking()).single;
    final raw = const BuildPassQr(MetroQrCodec()).parking(pass);
    expect(const MetroQrCodec().decode(raw)!.kind, QrKind.parking);
  });

  testWidgets('ScreenGuard: vào thì bật, rời thì khôi phục độ sáng', (
    tester,
  ) async {
    final guard = _FakeGuard();
    await tester.pumpWidget(
      ScreenGuard(service: guard, child: const SizedBox()),
    );
    expect(guard.calls, ['enable']);
    await tester.pumpWidget(const SizedBox());
    expect(guard.calls, ['enable', 'disable']);
  });
}
