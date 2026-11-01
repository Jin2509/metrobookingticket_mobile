import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';
import 'package:metro_mobile/features/auth/auth_demo.dart';
import 'package:metro_mobile/features/auth/data/dtos/session_user_dto.dart';
import 'package:metro_mobile/features/auth/data/dtos/token_pair_dto.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_fake_accounts.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_source.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// Giả lập backend trong bộ nhớ, đủ các nhánh lỗi 400/401/403/409/429.
class AuthFakeSource implements AuthSource {
  AuthFakeSource(
    this._store, {
    this.latency = const Duration(milliseconds: 600),
  }) : _accounts = {for (final a in seedFakeAccounts()) a.email: a};

  final SecureStore _store;
  final Duration latency;
  final Map<String, FakeAccount> _accounts;

  static const _accessPrefix = 'fake-access-';
  static const _refreshPrefix = 'fake-refresh-';
  static const _ticketPrefix = 'fake-ticket-';
  static const _invalidOtp = ValidationFailure('Mã OTP không hợp lệ');

  Future<void> _wait() => Future<void>.delayed(latency);

  FakeAccount? _find(String email) => _accounts[email.trim().toLowerCase()];

  /// Tài khoản của token đang lưu (không có token access thì coi như refresh).
  Future<FakeAccount> _current() async {
    final token = await _store.accessToken ?? await _store.refreshToken ?? '';
    final email = token
        .replaceFirst(_accessPrefix, '')
        .replaceFirst(_refreshPrefix, '');
    final acc = _accounts[email];
    if (acc == null) throw const UnauthorizedFailure();
    return acc;
  }

  void _checkOtp(String code) {
    if (code != AuthDemo.otp) throw _invalidOtp;
  }

  SessionUser _user(FakeAccount a) => SessionUserDto.fromJson(a.toUserJson());

  @override
  Future<TokenPairDto> login(String email, String password) async {
    await _wait();
    final acc = _find(email);
    if (acc == null || acc.password != password) {
      throw const UnauthorizedFailure('Email hoặc mật khẩu không đúng');
    }
    if (!acc.verified) throw const EmailNotVerifiedFailure();
    if (acc.locked) throw const AccountLockedFailure();
    if (acc.twoFactorEnabled) {
      throw TwoFactorRequiredFailure(
        '$_ticketPrefix${acc.email}',
        const Duration(minutes: 10),
      );
    }
    return _tokens(acc);
  }

  TokenPairDto _tokens(FakeAccount acc) => TokenPairDto(
    accessToken: '$_accessPrefix${acc.email}',
    refreshToken: '$_refreshPrefix${acc.email}',
  );

  @override
  Future<TokenPairDto> verifyLoginCode(String ticket, String code) async {
    await _wait();
    final acc = _accounts[ticket.replaceFirst(_ticketPrefix, '')];
    if (acc == null) throw _invalidOtp;
    _checkOtp(code);
    return _tokens(acc);
  }

  @override
  Future<void> resendLoginCode(String ticket) => _wait();

  @override
  Future<void> register(String name, String email, String password) async {
    await _wait();
    final key = email.toLowerCase();
    final existing = _accounts[key];
    if (existing != null) {
      if (existing.verified) {
        throw const ConflictFailure('Tài khoản đã tồn tại');
      }
      throw const RateLimitedFailure(
        RateLimitedFailure.defaultMessage,
        Duration(minutes: 9),
      );
    }
    _accounts[key] = FakeAccount(
      id: 'u-${_accounts.length + 1}',
      email: key,
      name: name,
      password: password,
      verified: false,
    );
  }

  @override
  Future<void> verifyEmail(String email, String code) async {
    await _wait();
    final acc = _find(email);
    if (acc == null) throw _invalidOtp;
    _checkOtp(code);
    acc.verified = true;
  }

  /// Luôn 202, không để lộ email có tồn tại hay không.
  @override
  Future<void> resendCode(String email) => _wait();

  /// Luôn 202, không để lộ email có tồn tại hay không.
  @override
  Future<void> forgotPassword(String email) => _wait();

  @override
  Future<void> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    await _wait();
    final acc = _find(email);
    if (acc == null) throw _invalidOtp;
    _checkOtp(code);
    acc.password = newPassword;
  }

  @override
  Future<void> logout(String refreshToken) async {}

  @override
  Future<SessionUser> me() async => _user(await _current());

  @override
  Future<SessionUser> updateProfile({
    required String name,
    String? newEmail,
    String? currentPassword,
  }) async {
    await _wait();
    final acc = await _current();
    if (newEmail != null) {
      if (currentPassword != acc.password) {
        throw const ValidationFailure('Mật khẩu hiện tại không đúng');
      }
      if (_find(newEmail) != null) {
        throw const ConflictFailure('Email đã có người dùng');
      }
      acc.pendingEmail = newEmail.toLowerCase();
    }
    acc.name = name;
    return _user(acc);
  }

  @override
  Future<SessionUser> verifyNewEmail(String email, String code) async {
    await _wait();
    final acc = await _current();
    _checkOtp(code);
    if (acc.pendingEmail != email.toLowerCase()) throw _invalidOtp;
    _accounts
      ..remove(acc.email)
      ..[email.toLowerCase()] = acc;
    acc
      ..email = email.toLowerCase()
      ..pendingEmail = null;
    return _user(acc);
  }

  @override
  Future<SessionUser> setTwoFactor({
    required bool enabled,
    required String currentPassword,
  }) async {
    await _wait();
    final acc = await _current();
    if (currentPassword != acc.password) {
      throw const ValidationFailure('Mật khẩu hiện tại không đúng');
    }
    acc.twoFactorEnabled = enabled;
    return _user(acc);
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _wait();
    final acc = await _current();
    if (currentPassword != acc.password) {
      throw const ValidationFailure('Mật khẩu hiện tại không đúng');
    }
    acc.password = newPassword;
  }
}
