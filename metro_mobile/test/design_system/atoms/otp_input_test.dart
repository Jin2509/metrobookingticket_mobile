import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/atoms/otp_cell.dart';
import 'package:metro_mobile/design_system/atoms/otp_input.dart';

import '../../helpers/pump_themed.dart';

List<String> _digits(WidgetTester tester) => tester
    .widgetList<OtpCell>(find.byType(OtpCell))
    .map((c) => c.digit)
    .toList();

void main() {
  testWidgets('gõ đủ 6 số thì gọi onCompleted', (tester) async {
    String? completed;
    await pumpThemed(tester, OtpInput(onCompleted: (v) => completed = v));

    await tester.enterText(find.byType(TextField), '4812');
    await tester.pump();
    expect(_digits(tester), ['4', '8', '1', '2', '', '']);
    expect(completed, isNull);

    await tester.enterText(find.byType(TextField), '481239');
    await tester.pump();
    expect(completed, '481239');
  });

  testWidgets('dán chuỗi lẫn chữ: chỉ giữ số, tối đa 6 ký tự', (tester) async {
    String? completed;
    await pumpThemed(tester, OtpInput(onCompleted: (v) => completed = v));

    await tester.enterText(find.byType(TextField), 'Mã: 12-34 56 789');
    await tester.pump();
    expect(_digits(tester), ['1', '2', '3', '4', '5', '6']);
    expect(completed, '123456');
  });

  testWidgets('xóa lùi làm trống ô cuối', (tester) async {
    final ctrl = TextEditingController(text: '123456');
    addTearDown(ctrl.dispose);
    await pumpThemed(tester, OtpInput(controller: ctrl));

    await tester.enterText(find.byType(TextField), '12345');
    await tester.pump();
    expect(_digits(tester), ['1', '2', '3', '4', '5', '']);
  });
}
