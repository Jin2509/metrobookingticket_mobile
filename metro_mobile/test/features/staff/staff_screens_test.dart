import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/core/permissions/camera_permission.dart';
import 'package:metro_mobile/core/qr/qr_payload.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/ticket_control/presentation/widgets/camera_denied_view.dart';

import '../../helpers/test_app.dart';

Future<void> _scan(
  WidgetTester t,
  ScannerHub hub,
  String token, {
  QrKind kind = QrKind.ticket,
}) async {
  hub.last.show(kind, token);
  await settle(t);
}

Finder _sheet(bool valid) =>
    find.byWidgetPredicate((w) => w is ScanResultSheet && w.valid == valid);

void main() {
  testWidgets('S10/S11: hợp lệ → sheet XANH tự đóng 2,5s, cộng thống kê', (
    tester,
  ) async {
    final hub = ScannerHub();
    final c = await pumpStaffAt(tester, '/s/scan', scanners: hub);
    expect(find.text('Ga Thủ Đức · Ca 06:00–14:00'), findsOneWidget);
    expect(find.byType(ScanView), findsOneWidget);
    expect(find.text('412'), findsOneWidget);

    await _scan(tester, hub, 'tk_mau01');
    expect(_sheet(true), findsOneWidget);
    expect(find.text('VÉ HỢP LỆ'), findsOneWidget);
    expect(
      find.textContaining('Vé lượt · Bến Thành – Thủ Đức'),
      findsOneWidget,
    );
    expect(find.text('413'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2600));
    await settle(tester);
    expect(_sheet(true), findsNothing);
    await unmount(tester, c);
  });

  testWidgets('quét trùng trong 3s chỉ ghi nhận một lần', (tester) async {
    final hub = ScannerHub();
    final c = await pumpStaffAt(tester, '/s/scan', scanners: hub);
    await _scan(tester, hub, 'tk_mau01');
    await _scan(tester, hub, 'tk_mau01');
    expect(c.read(demoLedgerProvider).scanLog, hasLength(1));
    await unmount(tester, c);
  });

  testWidgets('hết hạn, sai loại QR, không đọc được', (tester) async {
    final hub = ScannerHub();
    final c = await pumpStaffAt(tester, '/s/scan', scanners: hub);
    await _scan(tester, hub, 'tk_mau03');
    expect(_sheet(false), findsOneWidget);
    expect(find.text('Lý do: Vé hết hạn'), findsOneWidget);
    await tester.tap(find.text('Quét tiếp'));
    await settle(tester);

    await _scan(tester, hub, 'pk_mau1', kind: QrKind.parking);
    expect(find.text('Lý do: Mã QR không đúng loại'), findsOneWidget);
    await tester.tap(find.text('Quét tiếp'));
    await settle(tester);

    hub.last.garbage();
    await settle(tester);
    expect(find.text('Không đọc được mã QR. Quét lại'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('Ra ga sai ga + nhập mã thủ công (đã dùng)', (tester) async {
    final hub = ScannerHub();
    final c = await pumpStaffAt(tester, '/s/scan?mode=EXIT', scanners: hub);
    await _scan(tester, hub, 'tk_mau04');
    expect(find.text('Lý do: Check-out sai ga'), findsOneWidget);
    expect(find.text('Ga hiện tại: Thủ Đức'), findsOneWidget);
    await tester.tap(find.text('Quét tiếp'));
    await settle(tester);

    await tester.tap(find.text('VÀO GA'));
    await settle(tester);
    await tester.tap(find.widgetWithText(MetroButton, 'Nhập mã vé thủ công'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, 'VE-MAU-02');
    await tester.tap(find.widgetWithText(MetroButton, 'Kiểm tra'));
    await settle(tester);
    expect(find.text('Lý do: Vé đã được sử dụng'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('từ chối camera → hướng dẫn + vẫn nhập mã được', (tester) async {
    final c = await pumpStaffAt(
      tester,
      '/s/scan',
      camera: CameraAccess.permanentlyDenied,
    );
    expect(find.byType(CameraDeniedView), findsOneWidget);
    expect(find.text('Mở cài đặt'), findsOneWidget);
    expect(
      find.widgetWithText(MetroButton, 'Nhập mã vé thủ công'),
      findsOneWidget,
    );
    await unmount(tester, c);
  });

  testWidgets('S20/S21: quét QR gửi xe → Chưa gửi → Đang gửi', (tester) async {
    final hub = ScannerHub();
    final c = await pumpStaffAt(tester, '/s/parking', scanners: hub);
    expect(find.text('Bãi PK2 · Thủ Đức'), findsOneWidget);
    expect(find.text('59X2-111.22'), findsOneWidget);
    await tester.tap(find.widgetWithText(MetroButton, 'Quét QR gửi xe'));
    await settle(tester);
    expect(currentPath(c), '/s/parking/scan');
    await _scan(tester, hub, 'pk_mau1', kind: QrKind.parking);
    expect(currentPath(c), '/s/parking');
    expect(find.text('Chưa gửi'), findsOneWidget);
    expect(find.text('Đang gửi'), findsOneWidget);
    expect(find.text('51G-888.88'), findsNWidgets(2));
    await unmount(tester, c);
  });

  testWidgets('kịch bản 12.1: mua vé → nhân viên soát vào/ra → lịch sử', (
    tester,
  ) async {
    final hub = ScannerHub();
    final c = await pumpPassengerAt(
      tester,
      '/p/book?type=SINGLE&from=BT&to=TD',
      scanners: hub,
    );
    // Máy A: thanh toán (fake tự thành công sau 3s).
    await tester.tap(
      find.widgetWithText(MetroButton, 'Thanh toán bằng QR · 9.120 ₫'),
    );
    await settle(tester);
    await tester.pump(const Duration(seconds: 3));
    await settle(tester);
    expect(find.text('Thanh toán thành công'), findsOneWidget);
    final ledger = c.read(demoLedgerProvider);
    final ticket = ledger.findTicket('VE-80021')!;

    // Cùng DemoLedger = hai máy dùng chung backend.
    c.read(appRouterProvider).go('/p/account');
    await settle(tester);
    await tester.tap(find.text('Đăng xuất'));
    await settle(tester);
    await tester.tap(find.widgetWithText(TextButton, 'Đăng xuất'));
    await settle(tester);
    await login(tester, 'staff@metro.vn', 'Metro@123');
    expect(currentPath(c), '/s/scan');

    // Máy B: Vào ga → XANH, vé chuyển Đang sử dụng.
    await _scan(tester, hub, ticket['qrToken']! as String);
    expect(_sheet(true), findsOneWidget);
    expect(ticket['status'], 'IN_USE');
    await tester.pump(const Duration(seconds: 3));
    await settle(tester);

    // Quét lại → ĐỎ "Vé đã được check-in".
    await _scan(tester, hub, ticket['qrToken']! as String);
    expect(find.text('Lý do: Vé đã được check-in'), findsOneWidget);
    await tester.tap(find.text('Quét tiếp'));
    await settle(tester);

    // Ra ga → XANH, vé Đã sử dụng.
    await tester.tap(find.text('RA GA'));
    await settle(tester);
    await _scan(tester, hub, ticket['qrToken']! as String);
    expect(_sheet(true), findsOneWidget);
    expect(ticket['status'], 'USED');
    await tester.pump(const Duration(seconds: 3));
    await settle(tester);

    // Lịch sử: đủ 3 lượt, không có tên/email hành khách.
    await tester.tap(find.text('Lịch sử'));
    await settle(tester);
    expect(find.text('VE-80021'), findsNWidgets(3));
    expect(find.textContaining('Minh Anh'), findsNothing);
    expect(find.textContaining('passenger@'), findsNothing);
    await unmount(tester, c);
  });
}
