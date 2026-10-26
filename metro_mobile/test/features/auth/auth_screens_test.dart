import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/locked_banner.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('401: sai mật khẩu hiện lỗi dưới form', (tester) async {
    final c = await pumpApp(tester);
    expect(currentPath(c), '/auth/login');
    await login(tester, AuthDemo.passenger, 'sai-mat-khau');
    expect(find.text('Sai thông tin đăng nhập'), findsOneWidget);
    expect(currentPath(c), '/auth/login');
  });

  testWidgets('403: tài khoản bị khóa hiện banner đỏ', (tester) async {
    await pumpApp(tester);
    await login(tester, AuthDemo.locked, AuthDemo.password);
    expect(find.byType(LockedBanner), findsOneWidget);
    expect(find.textContaining('Tài khoản đã bị khóa'), findsOneWidget);
  });

  testWidgets('409: đăng ký email đã tồn tại', (tester) async {
    final c = await pumpApp(tester);
    await tester.tap(find.widgetWithText(TextButton, 'Đăng ký'));
    await settle(tester);
    expect(currentPath(c), '/auth/register');

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Minh Anh');
    await tester.enterText(fields.at(1), AuthDemo.passenger);
    await tester.enterText(fields.at(2), 'Metro2026');
    await tester.enterText(fields.at(3), 'Metro2026');
    await tester.tap(find.byType(Checkbox));
    final submit = find.widgetWithText(MetroButton, 'Tiếp tục');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await settle(tester);
    expect(find.text('Tài khoản đã tồn tại'), findsOneWidget);
  });

  testWidgets('2FA: OTP sai rung báo lỗi, gửi lại sau 60s, đúng thì vào app', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    await login(tester, AuthDemo.twoFactor, AuthDemo.password);
    expect(currentPath(c), startsWith('/auth/otp?purpose=LOGIN_2FA'));
    expect(find.text('Gửi lại mã (sau 60s)'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '000000');
    await settle(tester);
    expect(find.text('Mã OTP không hợp lệ'), findsOneWidget);

    await tester.pump(const Duration(seconds: 60));
    final resend = find.widgetWithText(TextButton, 'Gửi lại mã');
    expect(tester.widget<TextButton>(resend).onPressed, isNotNull);
    await tester.tap(resend);
    await settle(tester);
    expect(find.text('Đã gửi lại mã OTP'), findsOneWidget);
    expect(find.textContaining('Gửi lại mã (sau'), findsOneWidget);

    await tester.enterText(find.byType(TextField), AuthDemo.otp);
    await settle(tester);
    expect(currentPath(c), '/p/home');
  });
}
