import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_fake_source.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';

void main() {
  late AuthRepositoryImpl repo;
  late SecureStore store;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    store = SecureStore();
    repo = AuthRepositoryImpl(AuthFakeSource(latency: Duration.zero), store);
  });

  test(
    'đăng nhập lưu token, khôi phục được phiên, đăng xuất xóa sạch',
    () async {
      final result = await repo.login(
        identifier: AuthDemo.staff,
        password: AuthDemo.password,
        remember: true,
      );
      expect((result as LoginSucceeded).user.role, Role.staffStation);
      expect(await store.refreshToken, isNotNull);

      final fresh = AuthRepositoryImpl(
        AuthFakeSource(latency: Duration.zero),
        SecureStore(),
      );
      expect((await fresh.restore())?.email, AuthDemo.staff);

      await repo.logout();
      expect(await store.refreshToken, isNull);
      final afterLogout = AuthRepositoryImpl(
        AuthFakeSource(latency: Duration.zero),
        SecureStore(),
      );
      expect(await afterLogout.restore(), isNull);
    },
  );

  test('không "Ghi nhớ" thì token không ghi xuống bộ nhớ máy', () async {
    await repo.login(
      identifier: AuthDemo.passenger,
      password: AuthDemo.password,
      remember: false,
    );
    expect(await store.accessToken, isNotNull);
    expect(await SecureStore().refreshToken, isNull);
  });

  test('401 sai mật khẩu, 403 tài khoản khóa', () {
    expect(
      repo.login(identifier: AuthDemo.passenger, password: 'x', remember: true),
      throwsA(isA<UnauthorizedFailure>()),
    );
    expect(
      repo.login(
        identifier: AuthDemo.locked,
        password: AuthDemo.password,
        remember: true,
      ),
      throwsA(isA<AccountLockedFailure>()),
    );
  });

  test('tài khoản 2FA: cần OTP rồi mới có phiên', () async {
    final r = await repo.login(
      identifier: AuthDemo.twoFactor,
      password: AuthDemo.password,
      remember: true,
    );
    expect(r, isA<LoginNeedsOtp>());
    expect(
      repo.verifyOtp(
        purpose: OtpPurpose.login2fa,
        email: AuthDemo.twoFactor,
        code: '000000',
      ),
      throwsA(isA<ValidationFailure>()),
    );
    final v = await repo.verifyOtp(
      purpose: OtpPurpose.login2fa,
      email: AuthDemo.twoFactor,
      code: AuthDemo.otp,
    );
    expect((v as OtpSignedIn).user.email, AuthDemo.twoFactor);
  });

  test(
    'quên mật khẩu → OTP → đặt mật khẩu mới → đăng nhập bằng mật khẩu mới',
    () async {
      await repo.forgotPassword(AuthDemo.passenger);
      final v = await repo.verifyOtp(
        purpose: OtpPurpose.reset,
        email: AuthDemo.passenger,
        code: AuthDemo.otp,
      );
      await repo.resetPassword(
        resetToken: (v as OtpResetAllowed).resetToken,
        newPassword: 'NewPass2026',
      );
      final r = await repo.login(
        identifier: AuthDemo.passenger,
        password: 'NewPass2026',
        remember: true,
      );
      expect(r, isA<LoginSucceeded>());
    },
  );
}
