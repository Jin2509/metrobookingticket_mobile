import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/payment.dart';

import '../../helpers/test_app.dart';

Future<void> _tapButton(WidgetTester tester, String label) async {
  final f = find.widgetWithText(MetroButton, label);
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void main() {
  testWidgets('Trang chủ: nút Mua vé mở P29, điền sẵn ga đang chọn', (
    tester,
  ) async {
    final c = await pumpPassengerAt(tester, '/p/home');
    await tester.tap(find.text('Mua vé').first);
    await settle(tester);
    expect(currentPath(c), '/p/buy?from=BT');
    await unmount(tester, c);
  });

  testWidgets('đặt vé lượt từ màn Xác nhận vé (mục 7.2)', (tester) async {
    final c = await pumpPassengerAt(
      tester,
      '/p/book?type=SINGLE&from=BT&to=TD',
    );
    expect(find.text('Xác nhận vé'), findsOneWidget);
    expect(find.text('-600 ₫'), findsOneWidget);

    // Chạm 2: thanh toán bằng QR → QR 10:00, chờ xác nhận.
    await _tapButton(tester, 'Thanh toán bằng QR · 11.400 ₫');
    expect(currentPath(c), startsWith('/p/book/payment/DH'));
    expect(find.byType(PaymentQrSheet), findsOneWidget);
    expect(find.text('Đang chờ xác nhận thanh toán…'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await settle(tester);
    expect(find.text('Thanh toán thành công'), findsOneWidget);
    // Futu vui ở cả màn kết quả lẫn thông báo nổi.
    final mascots = tester.widgetList<MetroMascot>(find.byType(MetroMascot));
    expect(mascots.every((m) => m.mood == MascotMood.happy), isTrue);
    expect(find.textContaining('Mở QR là lên tàu'), findsOneWidget);
    expect(find.textContaining('kg CO₂'), findsOneWidget);

    // Chạm 3: mở QR vé.
    await _tapButton(tester, 'Mở QR vé');
    expect(currentPath(c), '/p/tickets/VE-80021');
    expect(find.text('Mã: VE-80021'), findsOneWidget);
    expect(find.byType(QrPassView), findsOneWidget);
    expect(find.text('Chưa sử dụng'), findsOneWidget);
    expect(c.read(demoLedgerProvider).tickets.first['id'], 'VE-80021');
    await unmount(tester, c);
  });

  testWidgets('A2 thanh toán thất bại → Thử lại', (tester) async {
    final c = await pumpPassengerAt(
      tester,
      '/p/book?type=DAY',
      paymentOutcome: PaymentStatus.failed,
    );
    await _tapButton(tester, 'Thanh toán bằng QR · 38.000 ₫');
    await tester.pump(const Duration(seconds: 3));
    await settle(tester);
    expect(find.text('Thanh toán thất bại'), findsOneWidget);
    expect(find.widgetWithText(MetroButton, 'Thử lại'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('A4 đã trừ tiền nhưng lỗi tạo vé → đang hoàn tiền', (
    tester,
  ) async {
    final c = await pumpPassengerAt(
      tester,
      '/p/book?type=DAY',
      paymentOutcome: PaymentStatus.refundPending,
    );
    await _tapButton(tester, 'Thanh toán bằng QR · 38.000 ₫');
    await tester.pump(const Duration(seconds: 3));
    await settle(tester);
    expect(find.text('Đang xử lý hoàn tiền'), findsOneWidget);
    expect(find.textContaining('Mã tra soát: TS-'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('A3 hủy giao dịch → về Trang chủ, không tạo vé', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/book?type=DAY');
    final before = c.read(demoLedgerProvider).tickets.length;
    await _tapButton(tester, 'Thanh toán bằng QR · 38.000 ₫');
    await _tapButton(tester, 'Hủy giao dịch');
    await tester.tap(find.widgetWithText(TextButton, 'Hủy giao dịch'));
    await settle(tester);
    expect(currentPath(c), '/p/home');
    expect(c.read(demoLedgerProvider).tickets.length, before);
    await unmount(tester, c);
  });
}
