import 'dart:convert';

import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';
import 'package:metro_mobile/features/auth/data/dtos/session_user_dto.dart';
import 'package:metro_mobile/features/auth/data/dtos/token_pair_dto.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_source.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._source, this._store);

  final AuthSource _source;
  final SecureStore _store;

  Future<SessionUser> _saveUser(SessionUser user) async {
    await _store.saveSession(jsonEncode(SessionUserDto.toJson(user)));
    return user;
  }

  @override
  Future<SessionUser?> restore() async {
    if (await _store.refreshToken == null) return null;
    try {
      // Token hết hạn thì `AuthInterceptor` tự refresh, không refresh ở đây để
      // tránh hai request refresh song song làm thu hồi cả phiên.
      return await _saveUser(await _source.me());
    } on UnauthorizedFailure {
      await _store.clear();
      return null;
    } on ForbiddenFailure {
      await _store.clear();
      return null;
    } on Failure {
      // Mất mạng/5xx: giữ token, dùng phiên đã lưu.
      final cached = await _store.sessionJson;
      if (cached == null) return null;
      return SessionUserDto.fromJson(
        jsonDecode(cached) as Map<String, dynamic>,
      );
    }
  }

  @override
  Future<SessionUser> login({
    required String email,
    required String password,
    required bool remember,
  }) async {
    return await _startSession(await _source.login(email, password), remember);
  }

  @override
  Future<SessionUser> verifyLoginCode({
    required String ticket,
    required String code,
    required bool remember,
  }) async {
    return await _startSession(
      await _source.verifyLoginCode(ticket, code),
      remember,
    );
  }

  @override
  Future<void> resendLoginCode(String ticket) =>
      _source.resendLoginCode(ticket);

  Future<SessionUser> _startSession(TokenPairDto tokens, bool remember) async {
    await _store.saveTokens(
      access: tokens.accessToken,
      refresh: tokens.refreshToken,
      persist: remember,
    );
    try {
      return await _saveUser(await _source.me());
    } on Failure {
      // Không lấy được quyền thì chưa vào được shell nào: hủy phiên vừa tạo.
      await logout();
      rethrow;
    }
  }

  @override
  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _source.register(name, email, password);
      return const RegisterResult();
    } on RateLimitedFailure catch (f) {
      return RegisterResult(alreadyPending: true, codeExpiresIn: f.retryAfter);
    }
  }

  @override
  Future<void> verifyEmail({required String email, required String code}) =>
      _source.verifyEmail(email, code);

  @override
  Future<void> resendCode(String email) => _source.resendCode(email);

  @override
  Future<void> forgotPassword(String email) => _source.forgotPassword(email);

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) => _source.resetPassword(email, code, newPassword);

  @override
  Future<void> logout() async {
    try {
      final refresh = await _store.refreshToken;
      if (refresh != null) await _source.logout(refresh);
    } on Object {
      // Bỏ qua lỗi mạng: token cục bộ vẫn phải bị xóa.
    } finally {
      await _store.clear();
    }
  }

  @override
  Future<SessionUser> reloadUser() => _source.me().then(_saveUser);

  @override
  Future<SessionUser> updateProfile({
    required String name,
    String? newEmail,
    String? currentPassword,
  }) => _source
      .updateProfile(
        name: name,
        newEmail: newEmail,
        currentPassword: currentPassword,
      )
      .then(_saveUser);

  @override
  Future<void> verifyNewEmail({
    required String email,
    required String code,
  }) async {
    await _source.verifyNewEmail(email, code);
    await _store.clear();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _source.changePassword(currentPassword, newPassword);
    await _store.clear();
  }

  @override
  Future<SessionUser> setTwoFactor({
    required bool enabled,
    required String currentPassword,
  }) => _source
      .setTwoFactor(enabled: enabled, currentPassword: currentPassword)
      .then(_saveUser);
}
