import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/design_system.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('P40: lọc trạng thái và tải dần khi cuộn', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/tickets');
    expect(find.text('Vé tháng HSSV'), findsOneWidget);

    await tester.tap(find.text('Chưa dùng'));
    await settle(tester);
    expect(find.byType(TicketCard), findsOneWidget);

    await tester.tap(find.text('Tất cả'));
    await settle(tester);
    await tester.drag(find.byType(ListView).last, const Offset(0, -6000));
    await settle(tester);
    await tester.drag(find.byType(ListView).last, const Offset(0, -6000));
    await settle(tester);
    expect(find.text('Đã hiển thị tất cả'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('P41: vé hết hạn → QR làm mờ, không có hướng dẫn quét', (
    tester,
  ) async {
    final c = await pumpPassengerAt(tester, '/p/tickets/VE-79957');
    final qr = tester.widget<QrPassView>(find.byType(QrPassView));
    expect(qr.active, isFalse);
    expect(find.text('Vé không còn hiệu lực'), findsOneWidget);
    expect(find.text('Hết hạn'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('P42: QR gửi xe mở từ tab Gửi xe', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/tickets');
    await tester.tap(find.text('Gửi xe'));
    await settle(tester);
    expect(find.text('59X1-234.56'), findsOneWidget);
    await tester.tap(find.widgetWithText(MetroButton, 'QR'));
    await settle(tester);
    expect(currentPath(c), '/p/tickets/parking/GX-1024');
    expect(find.text('Mã: GX-1024'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('P52: lịch sử giao dịch từ tab Tài khoản', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/account');
    await tester.tap(find.text('Lịch sử giao dịch'));
    await settle(tester);
    expect(currentPath(c), '/p/account/transactions');
    expect(find.text('Thất bại'), findsOneWidget);
    await unmount(tester, c);
  });
}
