import 'package:metro_mobile/features/auth/data/dtos/auth_payload_dto.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';

/// Lời gọi API thô. Có bản remote (Dio) và bản fake (demo offline).
abstract interface class AuthSource {
  Future<AuthPayloadDto> login(String identifier, String password);

  Future<void> register(String name, String email, String password);

  Future<AuthPayloadDto> verifyOtp(
    OtpPurpose purpose,
    String email,
    String code,
  );

  Future<void> resendOtp(OtpPurpose purpose, String email);

  Future<void> forgotPassword(String email);

  Future<void> resetPassword(String resetToken, String newPassword);

  Future<AuthPayloadDto> refresh(String refreshToken);

  Future<void> logout(String? refreshToken);
}
