import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/molecules/countdown_chip.dart';
import 'package:metro_mobile/design_system/molecules/ticket_card.dart';

import '../../helpers/pump_themed.dart';

void main() {
  testWidgets('CountdownChip đếm ngược và gọi onExpired', (tester) async {
    var expired = false;
    await pumpThemed(
      tester,
      CountdownChip(
        duration: const Duration(seconds: 3),
        onExpired: () => expired = true,
      ),
    );
    expect(find.text('00:03'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:02'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:00'), findsOneWidget);
    expect(expired, isTrue);
  });

  testWidgets('TicketCard: vé còn hiệu lực có "Mở QR"', (tester) async {
    var opened = 0;
    await pumpThemed(
      tester,
      TicketCard(
        title: 'Vé lượt',
        from: 'Bến Thành',
        to: 'Thủ Đức',
        status: 'PAID',
        validUntil: DateTime.utc(2026, 11, 23, 16, 59),
        onOpenQr: () => opened++,
      ),
    );
    expect(find.text('Chưa sử dụng'), findsOneWidget);
    expect(find.text('Hạn 23/11/2026 23:59'), findsOneWidget);
    await tester.tap(find.text('Mở QR'));
    expect(opened, 1);
  });

  testWidgets('TicketCard: vé hết hạn chỉ có "Chi tiết"', (tester) async {
    await pumpThemed(
      tester,
      TicketCard(
        title: 'Vé tháng',
        status: 'EXPIRED',
        validUntil: DateTime.utc(2026),
      ),
    );
    expect(find.text('Mở QR'), findsNothing);
    expect(find.text('Chi tiết'), findsOneWidget);
    expect(find.byType(Icon), findsWidgets);
  });
}
