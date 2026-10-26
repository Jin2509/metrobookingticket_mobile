import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/data/dtos/auth_payload_dto.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_fake_accounts.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_source.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';

/// Giả lập backend trong bộ nhớ, đủ các nhánh lỗi 401/403/404/409/400.
class AuthFakeSource implements AuthSource {
  AuthFakeSource({this.latency = const Duration(milliseconds: 600)})
    : _accounts = {for (final a in seedFakeAccounts()) a.email: a};

  final Duration latency;
  final Map<String, FakeAccount> _accounts;

  Future<void> _wait() => Future<void>.delayed(latency);

  FakeAccount _find(String email) {
    final acc = _accounts[email.trim().toLowerCase()];
    if (acc == null) throw const NotFoundFailure('Email chưa được đăng ký');
    return acc;
  }

  AuthPayloadDto _session(FakeAccount a) => AuthPayloadDto.fromJson({
    'accessToken': 'fake-access-${a.email}',
    'refreshToken': 'fake-refresh-${a.email}',
    'user': a.toUserJson(),
  });

  @override
  Future<AuthPayloadDto> login(String identifier, String password) async {
    await _wait();
    final acc = _accounts[identifier.toLowerCase()];
    if (acc == null || acc.password != password) {
      throw const UnauthorizedFailure();
    }
    if (acc.locked) throw const AccountLockedFailure();
    if (acc.requires2fa) return const AuthPayloadDto(requires2fa: true);
    return _session(acc);
  }

  @override
  Future<void> register(String name, String email, String password) async {
    await _wait();
    final key = email.toLowerCase();
    if (_accounts.containsKey(key)) {
      throw const ConflictFailure('Tài khoản đã tồn tại');
    }
    _accounts[key] = FakeAccount(
      id: 'u-${_accounts.length + 1}',
      email: key,
      name: name,
      role: 'PASSENGER',
      password: password,
    );
  }

  @override
  Future<AuthPayloadDto> verifyOtp(
    OtpPurpose purpose,
    String email,
    String code,
  ) async {
    await _wait();
    if (code != AuthDemo.otp) {
      throw const ValidationFailure('Mã OTP không hợp lệ');
    }
    final acc = _find(email);
    return purpose == OtpPurpose.reset
        ? AuthPayloadDto(resetToken: 'fake-reset-${acc.email}')
        : _session(acc);
  }

  @override
  Future<void> resendOtp(OtpPurpose purpose, String email) => _wait();

  @override
  Future<void> forgotPassword(String email) async {
    await _wait();
    _find(email);
  }

  @override
  Future<void> resetPassword(String resetToken, String newPassword) async {
    await _wait();
    const prefix = 'fake-reset-';
    if (!resetToken.startsWith(prefix)) {
      throw const ValidationFailure('Phiên đặt lại mật khẩu đã hết hạn');
    }
    _find(resetToken.substring(prefix.length)).password = newPassword;
  }

  @override
  Future<AuthPayloadDto> refresh(String refreshToken) async {
    const prefix = 'fake-refresh-';
    if (!refreshToken.startsWith(prefix)) throw const UnauthorizedFailure();
    return _session(_find(refreshToken.substring(prefix.length)));
  }

  @override
  Future<void> logout(String? refreshToken) async {}
}
