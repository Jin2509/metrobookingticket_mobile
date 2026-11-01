import 'package:metro_mobile/core/error/failure.dart';

/// Phản hồi của `POST /api/auth/login`.
class TokenPairDto {
  const TokenPairDto({required this.accessToken, required this.refreshToken});

  factory TokenPairDto.fromJson(Map<String, dynamic> json) {
    final access = json['accessToken'];
    final refresh = json['refreshToken'];
    if (access is! String || refresh is! String) throw const ServerFailure();
    return TokenPairDto(accessToken: access, refreshToken: refresh);
  }

  final String accessToken;
  final String refreshToken;
}
