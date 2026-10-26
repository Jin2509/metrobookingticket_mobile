import 'dart:convert';

import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/storage/secure_store.dart';
import 'package:metro_mobile/features/auth/data/dtos/auth_payload_dto.dart';
import 'package:metro_mobile/features/auth/data/dtos/session_user_dto.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_source.dart';
import 'package:metro_mobile/features/auth/domain/entities/auth_results.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';
import 'package:metro_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._source, this._store);

  final AuthSource _source;
  final SecureStore _store;

  /// Lựa chọn "Ghi nhớ" giữ lại cho bước OTP sau login.
  bool _remember = true;

  Future<SessionUser> _save(AuthPayloadDto p) async {
    if (!p.hasSession) throw const ServerFailure();
    await _store.saveTokens(
      access: p.accessToken!,
      refresh: p.refreshToken!,
      persist: _remember,
    );
    if (_remember) {
      await _store.saveSession(jsonEncode(SessionUserDto.toJson(p.user!)));
    }
    return p.user!;
  }

  @override
  Future<SessionUser?> restore() async {
    final refresh = await _store.refreshToken;
    if (refresh == null) return null;
    try {
      return await _save(await _source.refresh(refresh));
    } on NetworkFailure {
      // Mất mạng: dùng phiên đã lưu, gọi API sau sẽ tự refresh.
      final cached = await _store.sessionJson;
      if (cached == null) return null;
      return SessionUserDto.fromJson(
        jsonDecode(cached) as Map<String, dynamic>,
      );
    } on Failure {
      await _store.clear();
      return null;
    }
  }

  @override
  Future<LoginResult> login({
    required String identifier,
    required String password,
    required bool remember,
  }) async {
    _remember = remember;
    final payload = await _source.login(identifier, password);
    if (payload.requires2fa) return LoginNeedsOtp(identifier);
    return LoginSucceeded(await _save(payload));
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) {
    _remember = true;
    return _source.register(name, email, password);
  }

  @override
  Future<OtpVerification> verifyOtp({
    required OtpPurpose purpose,
    required String email,
    required String code,
  }) async {
    final payload = await _source.verifyOtp(purpose, email, code);
    if (purpose == OtpPurpose.reset) {
      final token = payload.resetToken;
      if (token == null) throw const ServerFailure();
      return OtpResetAllowed(token);
    }
    return OtpSignedIn(await _save(payload));
  }

  @override
  Future<void> resendOtp({
    required OtpPurpose purpose,
    required String email,
  }) => _source.resendOtp(purpose, email);

  @override
  Future<void> forgotPassword(String email) => _source.forgotPassword(email);

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) => _source.resetPassword(resetToken, newPassword);

  @override
  Future<void> logout() async {
    try {
      await _source.logout(await _store.refreshToken);
    } on Object {
      // Bỏ qua lỗi mạng: token cục bộ vẫn phải bị xóa.
    } finally {
      await _store.clear();
    }
  }
}
