import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/network/dio_client.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_remote_source.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';

import '../../helpers/fake_http.dart';

const _me = {
  'id': '158c41a0-70c8-4f5b-8b3f-18f409c3dea1',
  'email': 'an@example.com',
  'fullName': 'Nguyễn An',
  'status': 'ACTIVE',
  'roles': ['PASSENGER'],
  'permissions': ['TICKET_BUY', 'TICKET_VIEW_OWN'],
  'fieldMoi': 'phải bỏ qua',
};

Map<String, dynamic> _problem(int status, String detail) => {
  'detail': detail,
  'instance': '/api/x',
  'status': status,
  'title': 'Error',
};

void main() {
  late FakeHttpAdapter http;
  late AuthRemoteSource source;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    http = FakeHttpAdapter((_) => const FakeResponse(204));
    source = AuthRemoteSource(
      createDio(
        store: SecureStore(),
        onSessionExpired: () async {},
        onTokensRefreshed: () async {},
        baseUrl: 'http://test',
        adapter: http,
      ),
    );
  });

  RequestOptions last() => http.requests.last;

  group('đúng path, method, body', () {
    test('API 202/204 body rỗng không lỗi ép kiểu', () async {
      http.handler = (_) => const FakeResponse(202);
      await source.register('An', 'an@example.com', 'MatKhau@123');
      expect(last().path, '/api/auth/register');
      expect(last().data, {
        'fullName': 'An',
        'email': 'an@example.com',
        'password': 'MatKhau@123',
      });

      await source.resendCode('an@example.com');
      expect(last().path, '/api/auth/resend-code');
      expect(last().data, {'email': 'an@example.com'});

      await source.forgotPassword('an@example.com');
      expect(last().path, '/api/auth/forgot-password');
      expect(last().data, {'email': 'an@example.com'});
    });

    test('login 202: chưa có token, ném TwoFactorRequiredFailure', () async {
      final expiresAt = DateTime.now().toUtc().add(const Duration(minutes: 10));
      http.handler = (_) => FakeResponse(
        202,
        json: {
          'twoFactorRequired': true,
          'ticket': 'ticket-1',
          'expiresAt': expiresAt.toIso8601String(),
        },
      );
      await expectLater(
        source.login('an@example.com', 'MatKhau@123'),
        throwsA(
          isA<TwoFactorRequiredFailure>()
              .having((f) => f.ticket, 'ticket', 'ticket-1')
              .having(
                (f) => f.expiresIn!.inMinutes,
                'expiresIn',
                inInclusiveRange(9, 10),
              ),
        ),
      );
    });

    test('bước 2 đăng nhập và gửi lại mã', () async {
      http.handler = (_) => const FakeResponse(
        200,
        json: {'accessToken': 'a', 'refreshToken': 'r'},
      );
      final tokens = await source.verifyLoginCode('ticket-1', '012345');
      expect(tokens.refreshToken, 'r');
      expect(last().path, '/api/auth/login/2fa');
      expect(last().data, {'ticket': 'ticket-1', 'code': '012345'});

      http.handler = (_) => const FakeResponse(202);
      await source.resendLoginCode('ticket-1');
      expect(last().path, '/api/auth/login/2fa/resend');
      expect(last().data, {'ticket': 'ticket-1'});
    });

    test('bật 2FA: PUT /api/me/two-factor, đọc lại trạng thái', () async {
      http.handler = (_) =>
          const FakeResponse(200, json: {..._me, 'twoFactorEnabled': true});
      final user = await source.setTwoFactor(
        enabled: true,
        currentPassword: 'MatKhau@123',
      );
      expect(last().method, 'PUT');
      expect(last().path, '/api/me/two-factor');
      expect(last().data, {'enabled': true, 'currentPassword': 'MatKhau@123'});
      expect(user.twoFactorEnabled, isTrue);
    });

    test('OTP giữ dạng chuỗi, cả số 0 ở đầu', () async {
      await source.verifyEmail('an@example.com', '012345');
      expect(last().path, '/api/auth/verify-email');
      expect(last().data, {'email': 'an@example.com', 'code': '012345'});

      await source.resetPassword('an@example.com', '012345', 'Moi@45678');
      expect(last().path, '/api/auth/reset-password');
      expect(last().data, {
        'email': 'an@example.com',
        'code': '012345',
        'newPassword': 'Moi@45678',
      });
    });

    test('login gửi email, đọc được cặp token', () async {
      http.handler = (_) => const FakeResponse(
        200,
        json: {
          'accessToken': 'a',
          'tokenType': 'Bearer',
          'expiresAt': '2026-11-01T11:47:36.697837Z',
          'refreshToken': 'r',
          'refreshTokenExpiresAt': '2026-11-15T11:32:36.696621Z',
        },
      );
      final tokens = await source.login('an@example.com', 'x');
      expect(last().data, {'email': 'an@example.com', 'password': 'x'});
      expect(tokens.accessToken, 'a');
      expect(tokens.refreshToken, 'r');
    });

    test('logout gửi refresh token', () async {
      await source.logout('r');
      expect(last().path, '/api/auth/logout');
      expect(last().data, {'refreshToken': 'r'});
    });

    test('GET /api/me: quyền quyết định vai trò, bỏ qua field lạ', () async {
      http.handler = (_) => const FakeResponse(200, json: _me);
      final user = await source.me();
      expect(last().method, 'GET');
      expect(last().path, '/api/me');
      expect(user.name, 'Nguyễn An');
      expect(user.role, Role.passenger);
      expect(user.permissions, {'TICKET_BUY', 'TICKET_VIEW_OWN'});
    });

    test('PUT profile chỉ gửi email khi đổi email', () async {
      http.handler = (_) => const FakeResponse(200, json: _me);
      await source.updateProfile(name: 'Tên Mới');
      expect(last().method, 'PUT');
      expect(last().path, '/api/me/profile');
      expect(last().data, {'fullName': 'Tên Mới'});

      await source.updateProfile(
        name: 'Tên Mới',
        newEmail: 'moi@example.com',
        currentPassword: 'x',
      );
      expect(last().data, {
        'fullName': 'Tên Mới',
        'email': 'moi@example.com',
        'currentPassword': 'x',
      });
    });

    test('xác nhận email mới và đổi mật khẩu', () async {
      http.handler = (_) => const FakeResponse(200, json: _me);
      await source.verifyNewEmail('moi@example.com', '012345');
      expect(last().path, '/api/me/profile/verify-email');
      expect(last().data, {'email': 'moi@example.com', 'code': '012345'});

      http.handler = (_) => const FakeResponse(204);
      await source.changePassword('cu', 'MoiMoi@123');
      expect(last().method, 'PUT');
      expect(last().path, '/api/me/password');
      expect(last().data, {
        'currentPassword': 'cu',
        'newPassword': 'MoiMoi@123',
      });
    });
  });

  group('lỗi', () {
    Future<void> expectLoginFailure(
      FakeResponse response,
      Matcher matcher,
    ) async {
      http.handler = (_) => response;
      await expectLater(source.login('a@b.vn', 'x'), throwsA(matcher));
    }

    test('401 hiển thị đúng detail của backend', () async {
      await expectLoginFailure(
        FakeResponse(
          401,
          json: _problem(401, 'Email hoặc mật khẩu không đúng'),
        ),
        isA<UnauthorizedFailure>().having(
          (f) => f.message,
          'message',
          'Email hoặc mật khẩu không đúng',
        ),
      );
    });

    test('403 login phân biệt bằng detail', () async {
      await expectLoginFailure(
        FakeResponse(403, json: _problem(403, 'Email chưa được xác thực')),
        isA<EmailNotVerifiedFailure>(),
      );
      await expectLoginFailure(
        FakeResponse(403, json: _problem(403, 'Tài khoản đã bị khoá')),
        isA<AccountLockedFailure>(),
      );
    });

    test('403 body rỗng không lỗi parse', () async {
      await expectLoginFailure(
        const FakeResponse(403),
        isA<ForbiddenFailure>(),
      );
    });

    test('429 login không có Retry-After: báo thử lại sau 15 phút', () async {
      await expectLoginFailure(
        FakeResponse(429, json: _problem(429, 'Nhập sai quá nhiều lần')),
        isA<RateLimitedFailure>()
            .having((f) => f.retryAfter, 'retryAfter', isNull)
            .having((f) => f.message, 'message', contains('15 phút')),
      );
    });

    test('429 có Retry-After thì đọc được thời gian chờ', () async {
      http.handler = (_) => FakeResponse(
        429,
        json: _problem(429, 'Vui lòng đợi'),
        headers: const {'Retry-After': '42'},
      );
      await expectLater(
        source.resendCode('a@b.vn'),
        throwsA(
          isA<RateLimitedFailure>().having(
            (f) => f.retryAfter,
            'retryAfter',
            const Duration(seconds: 42),
          ),
        ),
      );
    });

    test('400 chỉ dùng detail, không hiện nội dung errors', () async {
      http.handler = (_) => FakeResponse(
        400,
        json: {
          ..._problem(400, 'Dữ liệu không hợp lệ'),
          'errors': {'email': 'must be a well-formed email address'},
        },
      );
      await expectLater(
        source.forgotPassword('a'),
        throwsA(
          isA<ValidationFailure>().having(
            (f) => f.message,
            'message',
            'Dữ liệu không hợp lệ',
          ),
        ),
      );
    });

    test('409, 5xx và mất mạng', () async {
      http.handler = (_) => FakeResponse(409, json: _problem(409, 'Trùng'));
      await expectLater(
        source.register('a', 'a@b.vn', 'x'),
        throwsA(isA<ConflictFailure>()),
      );
      http.handler = (_) => const FakeResponse(500);
      await expectLater(source.resendCode('a'), throwsA(isA<ServerFailure>()));
      http.handler = (req) => throw DioException.connectionError(
        requestOptions: req,
        reason: 'offline',
      );
      await expectLater(source.resendCode('a'), throwsA(isA<NetworkFailure>()));
    });
  });
}
