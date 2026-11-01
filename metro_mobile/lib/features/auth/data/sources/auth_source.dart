import 'package:metro_mobile/features/auth/data/dtos/token_pair_dto.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// Lời gọi API thô. Có bản remote (Dio) và bản fake (demo offline).
///
/// Không có `refresh`: chỉ `AuthInterceptor` được gọi `/api/auth/refresh`.
abstract interface class AuthSource {
  /// Tài khoản đã bật xác nhận 2 lớp: ném `TwoFactorRequiredFailure`.
  Future<TokenPairDto> login(String email, String password);

  Future<TokenPairDto> verifyLoginCode(String ticket, String code);

  Future<void> resendLoginCode(String ticket);

  Future<void> register(String name, String email, String password);

  Future<void> verifyEmail(String email, String code);

  Future<void> resendCode(String email);

  Future<void> forgotPassword(String email);

  Future<void> resetPassword(String email, String code, String newPassword);

  Future<void> logout(String refreshToken);

  Future<SessionUser> me();

  Future<SessionUser> updateProfile({
    required String name,
    String? newEmail,
    String? currentPassword,
  });

  Future<SessionUser> verifyNewEmail(String email, String code);

  Future<void> changePassword(String currentPassword, String newPassword);

  Future<SessionUser> setTwoFactor({
    required bool enabled,
    required String currentPassword,
  });
}
