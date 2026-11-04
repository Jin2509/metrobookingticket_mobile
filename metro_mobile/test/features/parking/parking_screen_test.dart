import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/design_system/design_system.dart';

import '../../helpers/test_app.dart';

Future<void> _plate(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextField), text);
  await settle(tester);
}

MetroButton _next(WidgetTester t) =>
    t.widget<MetroButton>(find.widgetWithText(MetroButton, 'Tiếp tục'));

Future<void> _tapNext(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(MetroButton, 'Tiếp tục'));
  await settle(tester);
}

void main() {
  testWidgets('A1 biển số sai: báo lỗi, khóa nút ở bước 2', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/parking/book');
    expect(find.byType(BookingStepper), findsOneWidget);
    await _tapNext(tester);
    await _plate(tester, '5G-12');
    expect(find.text('Biển số không đúng định dạng'), findsOneWidget);
    expect(_next(tester).onPressed, isNull);
    await unmount(tester, c);
  });

  testWidgets('A3 hết chỗ: ô tô ở Suối Tiên bị chặn ngay bước 1', (
    tester,
  ) async {
    final c = await pumpPassengerAt(tester, '/p/parking/book');
    await tester.tap(find.text('Ô tô'));
    await settle(tester);
    expect(find.text('Loại giữ xe đã hết chỗ'), findsOneWidget);
    expect(_next(tester).onPressed, isNull);
    await unmount(tester, c);
  });

  testWidgets('A4 còn lượt hiệu lực: banner + Xem QR', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/parking/book');
    await _tapNext(tester);
    await _plate(tester, '59X1-234.56');
    expect(find.text('Xe này đang có lượt gửi còn hiệu lực.'), findsOneWidget);
    expect(_next(tester).onPressed, isNull);
    await tester.tap(find.text('Xem QR'));
    await settle(tester);
    expect(currentPath(c), '/p/tickets/parking/GX-1024');
    await unmount(tester, c);
  });

  testWidgets('quay lại bước trước vẫn giữ biển số đã nhập', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/parking/book');
    await _tapNext(tester);
    await _plate(tester, '51G-888.88');
    await tester.tap(find.widgetWithText(MetroButton, 'Quay lại'));
    await settle(tester);
    await _tapNext(tester);
    expect(find.text('51G-888.88'), findsOneWidget);
    await unmount(tester, c);
  });

  testWidgets('đủ 3 bước → QR gửi xe, hiện ở Trang chủ', (tester) async {
    final c = await pumpPassengerAt(tester, '/p/parking/book');
    await _tapNext(tester);
    await _plate(tester, '51G-888.88');
    expect(find.text('Phí 5.000 ₫'), findsOneWidget);
    await _tapNext(tester);
    expect(find.text('51G-888.88'), findsOneWidget);
    expect(find.text('Phí 5.000 ₫'), findsOneWidget);
    await tester.tap(find.widgetWithText(MetroButton, 'Thanh toán'));
    await settle(tester);
    expect(find.byType(PaymentQrSheet), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await settle(tester);
    expect(find.text('Thanh toán thành công'), findsOneWidget);
    await tester.tap(find.widgetWithText(MetroButton, 'Mở QR gửi xe'));
    await settle(tester);
    expect(currentPath(c), startsWith('/p/tickets/parking/GX-'));
    expect(find.text('51G-888.88'), findsOneWidget);

    c.read(appRouterProvider).go('/p/home');
    await settle(tester);
    await tester.scrollUntilVisible(
      find.text('51G-888.88'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('51G-888.88'), findsOneWidget);
    await unmount(tester, c);
  });
}
