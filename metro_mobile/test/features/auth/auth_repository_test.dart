import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/data/dtos/token_pair_dto.dart';
import 'package:metro_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_fake_source.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_source.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:mocktail/mocktail.dart';

class _MockSource extends Mock implements AuthSource;

const _user = SessionUser(
  id: '1',
  name: 'An',
  email: 'an@metro.vn',
  role: Role.passenger,
);

void main() {
  late AuthRepositoryImpl repo;
  late SecureStore store;

  AuthRepositoryImpl freshApp() {
    final s = SecureStore();
    return AuthRepositoryImpl(AuthFakeSource(s, latency: Duration.zero), s);
  }

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    store = SecureStore();
    repo = AuthRepositoryImpl(
      AuthFakeSource(store, latency: Duration.zero),
      store,
    );
  });

  test(
    'đăng nhập lưu token, khôi phục được phiên, đăng xuất xóa sạch',
    () async {
      final user = await repo.login(
        email: AuthDemo.staff,
        password: AuthDemo.password,
        remember: true,
      );
      expect(user.role, Role.staffStation);
      expect(await store.refreshToken, isNotNull);

      expect((await freshApp().restore())?.email, AuthDemo.staff);

      await repo.logout();
      expect(await store.refreshToken, isNull);
      expect(await freshApp().restore(), isNull);
    },
  );

  test('không "Ghi nhớ" thì token không ghi xuống bộ nhớ máy', () async {
    await repo.login(
      email: AuthDemo.passenger,
      password: AuthDemo.password,
      remember: false,
    );
    expect(await store.accessToken, isNotNull);
    expect(await SecureStore().refreshToken, isNull);
  });

  test('401 sai mật khẩu, 403 khóa, 403 chưa xác thực', () {
    expect(
      repo.login(email: AuthDemo.passenger, password: 'x', remember: true),
      throwsA(isA<UnauthorizedFailure>()),
    );
    expect(
      repo.login(
        email: AuthDemo.locked,
        password: AuthDemo.password,
        remember: true,
      ),
      throwsA(isA<AccountLockedFailure>()),
    );
    expect(
      repo.login(
        email: AuthDemo.unverified,
        password: AuthDemo.password,
        remember: true,
      ),
      throwsA(isA<EmailNotVerifiedFailure>()),
    );
  });

  test('đăng ký → OTP → đăng nhập; xác thực không tự đăng nhập', () async {
    final result = await repo.register(
      name: 'An',
      email: 'an@metro.vn',
      password: 'Metro2026',
    );
    expect(result.alreadyPending, isFalse);
    expect(
      repo.verifyEmail(email: 'an@metro.vn', code: '000000'),
      throwsA(isA<ValidationFailure>()),
    );
    await repo.verifyEmail(email: 'an@metro.vn', code: AuthDemo.otp);
    expect(await store.refreshToken, isNull);
    final user = await repo.login(
      email: 'an@metro.vn',
      password: 'Metro2026',
      remember: true,
    );
    expect(user.role, Role.passenger);
  });

  test(
    'đăng ký email đang chờ xác thực: 429 thành kết quả, kèm hạn mã',
    () async {
      final result = await repo.register(
        name: 'An',
        email: AuthDemo.unverified,
        password: 'Metro2026',
      );
      expect(result.alreadyPending, isTrue);
      expect(result.codeExpiresIn, isNotNull);
    },
  );

  test(
    'quên mật khẩu → OTP + mật khẩu mới → đăng nhập bằng mật khẩu mới',
    () async {
      await repo.forgotPassword(AuthDemo.passenger);
      await repo.resetPassword(
        email: AuthDemo.passenger,
        code: AuthDemo.otp,
        newPassword: 'NewPass2026',
      );
      final user = await repo.login(
        email: AuthDemo.passenger,
        password: 'NewPass2026',
        remember: true,
      );
      expect(user.email, AuthDemo.passenger);
    },
  );

  test('quên mật khẩu không để lộ email có tồn tại hay không', () async {
    await repo.forgotPassword('khong-co@metro.vn');
  });

  test('đổi họ tên giữ phiên; đổi mật khẩu xóa token', () async {
    await repo.login(
      email: AuthDemo.passenger,
      password: AuthDemo.password,
      remember: true,
    );
    final updated = await repo.updateProfile(name: 'Tên Mới');
    expect(updated.name, 'Tên Mới');
    expect(await store.refreshToken, isNotNull);

    expect(
      repo.changePassword(currentPassword: 'sai', newPassword: 'NewPass2026'),
      throwsA(isA<ValidationFailure>()),
    );
    await repo.changePassword(
      currentPassword: AuthDemo.password,
      newPassword: 'NewPass2026',
    );
    expect(await store.refreshToken, isNull);
  });

  test('đổi email: email cũ tới khi xác nhận OTP, xong xóa token', () async {
    await repo.login(
      email: AuthDemo.passenger,
      password: AuthDemo.password,
      remember: true,
    );
    final updated = await repo.updateProfile(
      name: 'Minh Anh',
      newEmail: 'moi@metro.vn',
      currentPassword: AuthDemo.password,
    );
    expect(updated.email, AuthDemo.passenger);

    await repo.verifyNewEmail(email: 'moi@metro.vn', code: AuthDemo.otp);
    expect(await store.refreshToken, isNull);
    final user = await repo.login(
      email: 'moi@metro.vn',
      password: AuthDemo.password,
      remember: true,
    );
    expect(user.email, 'moi@metro.vn');
  });

  group('với source giả lập lỗi', () {
    late _MockSource source;
    setUp(() {
      source = _MockSource();
      repo = AuthRepositoryImpl(source, store);
    });

    Future<void> seedSession() async {
      when(() => source.login(any(), any())).thenAnswer(
        (_) async => const TokenPairDto(accessToken: 'a', refreshToken: 'r'),
      );
      when(source.me).thenAnswer((_) async => _user);
      await repo.login(email: 'an@metro.vn', password: 'x', remember: true);
    }

    test(
      'khôi phục khi mất mạng hoặc 5xx: giữ token, dùng phiên đã lưu',
      () async {
        await seedSession();
        for (final failure in const [NetworkFailure(), ServerFailure()]) {
          when(source.me).thenThrow(failure);
          expect((await repo.restore())?.email, _user.email);
          expect(await store.refreshToken, 'r');
        }
      },
    );

    test('khôi phục khi phiên bị từ chối: xóa token', () async {
      await seedSession();
      when(source.me).thenThrow(const UnauthorizedFailure());
      expect(await repo.restore(), isNull);
      expect(await store.refreshToken, isNull);
    });

    test('login được nhưng GET /api/me lỗi: hủy phiên vừa tạo', () async {
      when(() => source.login(any(), any())).thenAnswer(
        (_) async => const TokenPairDto(accessToken: 'a', refreshToken: 'r'),
      );
      when(source.me).thenThrow(const NetworkFailure());
      when(() => source.logout(any())).thenAnswer((_) async {});
      await expectLater(
        repo.login(email: 'an@metro.vn', password: 'x', remember: true),
        throwsA(isA<NetworkFailure>()),
      );
      verify(() => source.logout('r')).called(1);
      expect(await store.refreshToken, isNull);
    });

    test('đăng xuất khi API lỗi vẫn xóa token', () async {
      await seedSession();
      when(() => source.logout(any())).thenThrow(const NetworkFailure());
      await repo.logout();
      expect(await store.accessToken, isNull);
    });
  });
}
