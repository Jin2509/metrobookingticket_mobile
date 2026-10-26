import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/demo/demo_ledger.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/qr/qr_payload.dart';
import 'package:metro_mobile/features/staff/parking_control/data/sources/parking_control_fake_source.dart';
import 'package:metro_mobile/features/staff/parking_control/domain/usecases/parking_control_usecases.dart';
import 'package:metro_mobile/features/staff/scan_history/data/sources/scan_history_sources.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/usecases/get_scan_history.dart';
import 'package:metro_mobile/features/staff/shift/data/sources/shift_sources.dart';
import 'package:metro_mobile/features/staff/ticket_control/data/sources/ticket_control_fake_source.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/entities/scan_entities.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/usecases/check_ticket.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/usecases/dedupe_scan.dart';
import 'package:metro_mobile/features/staff/ticket_control/domain/usecases/process_ticket_scan.dart';

QrPayload _qr(QrKind k, String token) =>
    QrPayload(kind: k, token: token, issuedAt: DateTime(2026));

void main() {
  late DemoLedger ledger;
  late DateTime now;
  late ProcessTicketScan process;
  late TicketControlFakeSource source;

  setUp(() {
    ledger = DemoLedger();
    now = DateTime(2026, 10, 25, 8);
    source = TicketControlFakeSource(ledger, latency: Duration.zero);
    process = ProcessTicketScan(
      checkIn: CheckInTicket(source),
      checkOut: CheckOutTicket(source),
      clock: () => now,
    );
  });

  Future<ScanResult?> scan(String token, ScanMode mode, {String st = 'TD'}) =>
      process.payload(_qr(QrKind.ticket, token), mode, st);

  RejectReason? reason(ScanResult? r) => r is ScanInvalid ? r.reason : null;

  test('check-in hợp lệ rồi check-out → vé lượt thành Đã sử dụng', () async {
    final r = await scan('tk_mau01', ScanMode.entry);
    expect(r, isA<ScanValid>());
    expect((r! as ScanValid).route, 'Bến Thành – Thủ Đức');
    expect(ledger.findTicket('VE-MAU-01')!['status'], 'IN_USE');

    now = now.add(const Duration(minutes: 30));
    expect(await scan('tk_mau01', ScanMode.exit), isA<ScanValid>());
    expect(ledger.findTicket('VE-MAU-01')!['status'], 'USED');
  });

  test('chống quét trùng 3s, sau đó báo đã check-in', () async {
    await scan('tk_mau01', ScanMode.entry);
    now = now.add(const Duration(seconds: 2));
    expect(await scan('tk_mau01', ScanMode.entry), isNull);
    now = now.add(const Duration(seconds: 2));
    expect(
      reason(await scan('tk_mau01', ScanMode.entry)),
      RejectReason.alreadyIn,
    );
  });

  test('các lý do từ chối', () async {
    expect(reason(await scan('tk_mau02', ScanMode.entry)), RejectReason.used);
    expect(
      reason(await scan('tk_mau03', ScanMode.entry)),
      RejectReason.expired,
    );
    expect(
      reason(await scan('tk_khong_co', ScanMode.entry)),
      RejectReason.notFound,
    );
    final wrong = await scan('tk_mau04', ScanMode.exit);
    expect(reason(wrong), RejectReason.wrongStation);
    expect((wrong! as ScanInvalid).currentStation, 'Thủ Đức');
    expect((wrong as ScanInvalid).route, 'Bến Thành – An Phú');
    expect(reason(await scan('tk_mau01', ScanMode.exit)), RejectReason.notIn);
  });

  test('QR gửi xe ở màn soát vé → sai loại, không gọi API', () async {
    final r = await process.payload(
      _qr(QrKind.parking, 'pk_mau1'),
      ScanMode.entry,
      'TD',
    );
    expect(reason(r), RejectReason.wrongKind);
    expect(ledger.scanLog, isEmpty);
  });

  test('403 sai ga phân công → thông báo rõ ràng', () async {
    final r = await scan('tk_mau01', ScanMode.entry, st: 'BT');
    expect(reason(r), RejectReason.forbidden);
    expect(ledger.findTicket('VE-MAU-01')!['status'], 'PAID');
  });

  test('cùng Idempotency-Key chỉ ghi nhận một lần', () async {
    final a = await source.checkIn(
      qrTokenOrCode: 'tk_mau01',
      stationId: 'TD',
      idempotencyKey: 'K1',
    );
    final b = await source.checkIn(
      qrTokenOrCode: 'tk_mau01',
      stationId: 'TD',
      idempotencyKey: 'K1',
    );
    expect(identical(a, b), isTrue);
    expect(ledger.scanLog, hasLength(1));
  });

  test('nhập mã vé thủ công, vé tháng ra ga quay về Chưa sử dụng', () async {
    expect(
      await process.code('VE-79990', ScanMode.entry, 'TD'),
      isA<ScanValid>(),
    );
    now = now.add(const Duration(minutes: 5));
    expect(
      await process.code('ve-79990', ScanMode.exit, 'TD'),
      isA<ScanValid>(),
    );
    expect(ledger.findTicket('VE-79990')!['status'], 'PAID');
  });

  test('dedupe theo khóa riêng từng mã', () {
    var t = DateTime(2026);
    final d = DedupeScan(clock: () => t);
    expect(d.accept('a'), isTrue);
    expect(d.accept('b'), isTrue);
    expect(d.accept('a'), isFalse);
    t = t.add(const Duration(seconds: 3));
    expect(d.accept('a'), isTrue);
  });

  test('gửi xe: Chưa gửi → Đang gửi → Đã lấy xe → hết lượt', () async {
    final repo = ParkingControlFakeSource(ledger, latency: Duration.zero);
    final check = CheckParkingQr(repo);
    final p = _qr(QrKind.parking, 'pk_mau1');
    expect((await check(p, 'PK2-TD')).toStatus, 'DANG_GUI');
    expect(
      (await GetParkedVehicles(repo)('PK2-TD', query: '51g888')).single.plate,
      '51G-888.88',
    );
    expect((await check(p, 'PK2-TD')).toStatus, 'LAY_XE');
    expect(check(p, 'PK2-TD'), throwsA(isA<ConflictFailure>()));
    expect(
      check(_qr(QrKind.parking, 'pk_1024'), 'PK2-TD'),
      throwsA(isA<NotFoundFailure>()),
    );
    expect(
      () => check(_qr(QrKind.ticket, 'tk_mau01'), 'PK2-TD'),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('thống kê ca và lịch sử lọc từ chối, không có PII', () async {
    await scan('tk_mau01', ScanMode.entry);
    await scan('tk_mau02', ScanMode.entry);
    final stats = await ShiftFakeSource(ledger).getTodayStats();
    expect(stats.entries, 413);
    expect(stats.rejected, 8);
    final rejected = await GetScanHistory(ScanHistoryFakeSource(ledger))(
      ScanLogFilter.rejected,
    );
    expect(rejected.single.code, 'VE-MAU-02');
    expect(rejected.single.label, 'Vé đã được sử dụng');
  });
}
