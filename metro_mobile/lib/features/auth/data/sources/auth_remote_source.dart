import 'package:dio/dio.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/auth/data/dtos/auth_payload_dto.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_source.dart';
import 'package:metro_mobile/features/auth/domain/entities/otp_purpose.dart';

/// Endpoint theo mục 9. Lỗi Dio được map sang `Failure`.
class AuthRemoteSource implements AuthSource {
  const AuthRemoteSource(this._dio);
  final Dio _dio;

  Future<AuthPayloadDto> _post(String path, Map<String, dynamic> body) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(path, data: body);
      return AuthPayloadDto.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<AuthPayloadDto> login(String identifier, String password) =>
      _post('/api/auth/login', {'username': identifier, 'password': password});

  @override
  Future<void> register(String name, String email, String password) => _post(
    '/api/auth/register',
    {'fullName': name, 'email': email, 'password': password},
  );

  @override
  Future<AuthPayloadDto> verifyOtp(
    OtpPurpose purpose,
    String email,
    String code,
  ) => _post('/api/auth/verify-otp', {
    'purpose': purpose.value,
    'email': email,
    'otp': code,
  });

  @override
  Future<void> resendOtp(OtpPurpose purpose, String email) =>
      _post('/api/auth/resend-otp', {'purpose': purpose.value, 'email': email});

  @override
  Future<void> forgotPassword(String email) =>
      _post('/api/auth/forgot-password', {'email': email});

  @override
  Future<void> resetPassword(String resetToken, String newPassword) => _post(
    '/api/auth/reset-password',
    {'resetToken': resetToken, 'newPassword': newPassword},
  );

  @override
  Future<AuthPayloadDto> refresh(String refreshToken) =>
      _post('/api/auth/refresh', {'refreshToken': refreshToken});

  @override
  Future<void> logout(String? refreshToken) =>
      _post('/api/auth/logout', {'refreshToken': refreshToken});
}
