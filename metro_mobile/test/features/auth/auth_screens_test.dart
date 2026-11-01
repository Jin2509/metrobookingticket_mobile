import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/app/router/app_router.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:metro_mobile/features/auth/presentation/widgets/locked_banner.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('401: sai mật khẩu hiện lỗi dưới form', (tester) async {
    final c = await pumpApp(tester);
    expect(currentPath(c), '/auth/login');
    await login(tester, AuthDemo.passenger, 'sai-mat-khau');
    expect(find.text('Email hoặc mật khẩu không đúng'), findsOneWidget);
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

  testWidgets('403 chưa xác thực: sang OTP, sai báo lỗi, đúng về đăng nhập', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    await login(tester, AuthDemo.unverified, AuthDemo.password);
    expect(currentPath(c), startsWith('/auth/otp?email='));
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
    await tester.pump(const Duration(seconds: 5)); // SnackBar trên hết hạn

    await tester.enterText(find.byType(TextField), AuthDemo.otp);
    await settle(tester);
    expect(currentPath(c), '/auth/login');
    expect(
      find.text('Xác thực email thành công, hãy đăng nhập'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('đăng ký email đang chờ xác thực: sang OTP kèm cảnh báo', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c.read(appRouterProvider).go('/auth/register');
    await settle(tester);
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'An');
    await tester.enterText(fields.at(1), AuthDemo.unverified);
    await tester.enterText(fields.at(2), 'Metro2026');
    await tester.enterText(fields.at(3), 'Metro2026');
    await tester.tap(find.byType(Checkbox));
    final submit = find.widgetWithText(MetroButton, 'Tiếp tục');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await settle(tester);
    expect(currentPath(c), contains('expires=540'));
    expect(find.textContaining('chưa được lưu'), findsOneWidget);
    expect(find.text('Hết hạn sau 09:00'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('quên mật khẩu: OTP và mật khẩu mới cùng một màn', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c.read(appRouterProvider).go('/auth/forgot');
    await settle(tester);
    await tester.enterText(find.byType(TextField), AuthDemo.passenger);
    await tester.tap(find.widgetWithText(MetroButton, 'Gửi mã xác thực'));
    await settle(tester);
    expect(currentPath(c), startsWith('/auth/reset?email='));
    expect(
      find.textContaining('đã đăng ký, bạn sẽ nhận được mã'),
      findsOneWidget,
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), AuthDemo.otp);
    await tester.enterText(fields.at(1), 'NewPass2026');
    await tester.enterText(fields.at(2), 'NewPass2026');
    final save = find.widgetWithText(MetroButton, 'Lưu mật khẩu mới');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await settle(tester);
    expect(currentPath(c), '/auth/login');

    await login(tester, AuthDemo.passenger, 'NewPass2026');
    expect(currentPath(c), '/p/home');
  });

  testWidgets('hồ sơ: đổi tên giữ phiên, đổi mật khẩu về đăng nhập', (
    tester,
  ) async {
    final c = await pumpPassengerAt(tester, '/p/account/profile');
    await tester.enterText(find.byType(TextField).at(0), 'Tên Mới');
    final save = find.widgetWithText(MetroButton, 'Lưu thông tin');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await settle(tester);
    expect(c.read(authControllerProvider).value?.name, 'Tên Mới');
    expect(currentPath(c), '/p/account/profile');

    await tester.enterText(find.byType(TextField).at(2), AuthDemo.password);
    await tester.enterText(find.byType(TextField).at(3), 'NewPass2026');
    await tester.enterText(find.byType(TextField).at(4), 'NewPass2026');
    final change = find.widgetWithText(MetroButton, 'Đổi mật khẩu');
    await tester.ensureVisible(change);
    await tester.tap(change);
    await settle(tester);
    expect(currentPath(c), startsWith('/auth/login'));
    await unmount(tester, c);
  });

  testWidgets('2FA: đúng mật khẩu sang màn mã, sai báo lỗi, đúng vào app', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    await login(tester, AuthDemo.twoFactor, AuthDemo.password);
    expect(currentPath(c), startsWith('/auth/two-factor'));
    expect(c.read(authControllerProvider).value, isNull);

    await tester.enterText(find.byType(TextField), '000000');
    await settle(tester);
    expect(find.text('Mã OTP không hợp lệ'), findsOneWidget);
    expect(c.read(authControllerProvider).value, isNull);

    await tester.enterText(find.byType(TextField), AuthDemo.otp);
    await settle(tester);
    expect(c.read(authControllerProvider).value?.email, AuthDemo.twoFactor);
    expect(currentPath(c), '/p/home');
    await unmount(tester, c);
  });

  testWidgets('2FA: sai mật khẩu không sang màn mã', (tester) async {
    final c = await pumpApp(tester);
    await login(tester, AuthDemo.twoFactor, 'sai-mat-khau');
    expect(find.text('Email hoặc mật khẩu không đúng'), findsOneWidget);
    expect(currentPath(c), '/auth/login');
  });

  testWidgets('2FA: mở thẳng màn mã không có ticket thì về đăng nhập', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c.read(appRouterProvider).go('/auth/two-factor');
    await settle(tester);
    expect(currentPath(c), '/auth/login');
  });

  testWidgets('hồ sơ: bật 2FA cần mật khẩu, lần đăng nhập sau phải nhập mã', (
    tester,
  ) async {
    final c = await pumpPassengerAt(tester, '/p/account/profile');
    Future<void> toggle(String password) async {
      final tile = find.byType(SwitchListTile);
      await tester.ensureVisible(tile);
      await settle(tester);
      await tester.tap(tile);
      await settle(tester);
      await tester.enterText(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
        password,
      );
      await tester.tap(find.widgetWithText(TextButton, 'Xác nhận'));
      await settle(tester);
    }

    await toggle('sai-mat-khau');
    expect(find.text('Mật khẩu hiện tại không đúng'), findsOneWidget);
    expect(c.read(authControllerProvider).value?.twoFactorEnabled, isFalse);

    await toggle(AuthDemo.password);
    expect(find.text('Đã bật xác nhận 2 lớp'), findsOneWidget);
    expect(c.read(authControllerProvider).value?.twoFactorEnabled, isTrue);
    expect(currentPath(c), '/p/account/profile');

    await c.read(authControllerProvider.notifier).logout();
    await settle(tester);
    await login(tester, AuthDemo.passenger, AuthDemo.password);
    expect(currentPath(c), startsWith('/auth/two-factor'));
    await unmount(tester, c);
  });

  testWidgets('hồ sơ: đổi email cần mật khẩu, xác nhận OTP rồi đăng nhập lại', (
    tester,
  ) async {
    final c = await pumpPassengerAt(tester, '/p/account/profile');
    await tester.enterText(find.byType(TextField).at(1), 'moi@metro.vn');
    await settle(tester);
    await tester.enterText(find.byType(TextField).at(2), AuthDemo.password);
    final save = find.widgetWithText(MetroButton, 'Lưu thông tin');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await settle(tester);
    expect(currentPath(c), contains('/p/account/profile/verify-email'));
    expect(c.read(authControllerProvider).value?.email, AuthDemo.passenger);

    await tester.enterText(find.byType(TextField), AuthDemo.otp);
    await settle(tester);
    expect(currentPath(c), startsWith('/auth/login'));
    await login(tester, 'moi@metro.vn', AuthDemo.password);
    expect(c.read(authControllerProvider).value?.email, 'moi@metro.vn');
    await unmount(tester, c);
  });
}
