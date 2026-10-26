import 'package:metro_mobile/features/auth/data/dtos/session_user_dto.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// Phản hồi chung của `/api/auth/*`.
class AuthPayloadDto {
  const AuthPayloadDto({
    this.accessToken,
    this.refreshToken,
    this.user,
    this.requires2fa = false,
    this.resetToken,
  });

  factory AuthPayloadDto.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return AuthPayloadDto(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: user is Map<String, dynamic> ? SessionUserDto.fromJson(user) : null,
      requires2fa: json['requires2fa'] as bool? ?? false,
      resetToken: json['resetToken'] as String?,
    );
  }

  final String? accessToken;
  final String? refreshToken;
  final SessionUser? user;
  final bool requires2fa;
  final String? resetToken;

  bool get hasSession =>
      accessToken != null && refreshToken != null && user != null;
}
