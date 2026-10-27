import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/design_system/design_system.dart';

import '../../helpers/test_app.dart';

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void main() {
  testWidgets('P29 → P30 → P32 (SePay) → P33: mua vé ngày từ tab Vé', (
    tester,
  ) async {
    final c = await pumpPassengerAt(tester, '/p/tickets');
    await _tap(tester, find.text('Mua vé'));
    expect(currentPath(c), '/p/buy');
    expect(find.byType(BookingStepper), findsOneWidget);

    // Vé lượt chưa chọn ga → chưa tiếp tục được.
    final next = find.widgetWithText(MetroButton, 'Tiếp tục');
    expect(tester.widget<MetroButton>(next).onPressed, isNull);

    await _tap(tester, find.text('Vé ngày'));
    expect(find.text('Hành trình'), findsNothing);
    expect(find.text('40.000 ₫'), findsWidgets);
    await _tap(tester, next);
    expect(currentPath(c), '/p/book?type=DAY');
    expect(find.text('Chuyển khoản VietQR (SePay)'), findsOneWidget);

    await _tap(
      tester,
      find.widgetWithText(MetroButton, 'Thanh toán bằng QR · 38.000 ₫'),
    );
    expect(currentPath(c), startsWith('/p/book/payment/DH'));
    expect(find.text('Quét mã VietQR'), findsOneWidget);
    expect(find.text('MB Bank'), findsOneWidget);
    final order = c.read(demoLedgerProvider).orders.keys.last;
    expect(find.text(order), findsWidgets);

    // Sao chép nội dung chuyển khoản.
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    await _tap(tester, find.byTooltip('Sao chép').last);
    expect(copied, order);
    expect(find.text('Đã sao chép $order'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await settle(tester);
    expect(find.text('Thanh toán thành công'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('P29 vé lượt: chọn ga có giá, Đặt vé từ ga điền sẵn ga đi', (
    tester,
  ) async {
    final c = await pumpPassengerAt(tester, '/p/explore/stations/BT');
    await _tap(tester, find.widgetWithText(MetroButton, 'Đặt vé từ đây'));
    expect(currentPath(c), '/p/buy?from=BT');
    expect(find.text('Bến Thành'), findsOneWidget);

    await _tap(tester, find.text('Chọn ga'));
    await _tap(tester, find.text('Thủ Đức').last);
    expect(find.text('12.000 ₫'), findsWidgets);
    await _tap(tester, find.widgetWithText(MetroButton, 'Tiếp tục'));
    expect(currentPath(c), '/p/book?type=SINGLE&from=BT&to=TD');
    await unmount(tester, c);
  });
}
