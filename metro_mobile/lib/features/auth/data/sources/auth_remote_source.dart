import 'package:dio/dio.dart';
import 'package:metro_mobile/core/error/failure.dart';
import 'package:metro_mobile/core/network/api_exception.dart';
import 'package:metro_mobile/features/auth/data/dtos/session_user_dto.dart';
import 'package:metro_mobile/features/auth/data/dtos/token_pair_dto.dart';
import 'package:metro_mobile/features/auth/data/sources/auth_source.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// `/api/auth/*` và `/api/me/*`. Lỗi Dio được map sang `Failure`.
class AuthRemoteSource implements AuthSource {
  const AuthRemoteSource(this._dio);
  final Dio _dio;

  /// API 202/204: body rỗng nên không ép kiểu `Map`.
  Future<void> _post(String path, Map<String, dynamic> body) async {
    try {
      await _dio.post<dynamic>(path, data: body);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<SessionUser> _user(
    Future<Response<Map<String, dynamic>>> Function() request,
  ) async {
    try {
      return SessionUserDto.fromJson((await request()).data!);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<TokenPairDto> login(String email, String password) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );
      if (res.statusCode == 202) throw _twoFactorRequired(res.data!);
      return TokenPairDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _loginFailure(mapDioError(e));
    }
  }

  Failure _twoFactorRequired(Map<String, dynamic> json) {
    final ticket = json['ticket'];
    if (ticket is! String) return const ServerFailure();
    final expiresAt = DateTime.tryParse(json['expiresAt'] as String? ?? '');
    final left = expiresAt?.difference(DateTime.now());
    // Đồng hồ thiết bị sai có thể cho số âm: bỏ qua, dùng thời hạn mặc định.
    return TwoFactorRequiredFailure(
      ticket,
      left != null && left > Duration.zero ? left : null,
    );
  }

  @override
  Future<TokenPairDto> verifyLoginCode(String ticket, String code) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/auth/login/2fa',
        data: {'ticket': ticket, 'code': code},
      );
      return TokenPairDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<void> resendLoginCode(String ticket) =>
      _post('/api/auth/login/2fa/resend', {'ticket': ticket});

  /// Hai trường hợp 403 của login chỉ phân biệt được bằng `detail`.
  Failure _loginFailure(Failure failure) => switch (failure) {
    ForbiddenFailure(message: 'Email chưa được xác thực') =>
      const EmailNotVerifiedFailure(),
    ForbiddenFailure(message: 'Tài khoản đã bị khoá') =>
      const AccountLockedFailure(),
    RateLimitedFailure() => const RateLimitedFailure(
      'Bạn đã nhập sai quá nhiều lần, thử lại sau 15 phút',
    ),
    _ => failure,
  };

  @override
  Future<void> register(String name, String email, String password) => _post(
    '/api/auth/register',
    {'fullName': name, 'email': email, 'password': password},
  );

  @override
  Future<void> verifyEmail(String email, String code) =>
      _post('/api/auth/verify-email', {'email': email, 'code': code});

  @override
  Future<void> resendCode(String email) =>
      _post('/api/auth/resend-code', {'email': email});

  @override
  Future<void> forgotPassword(String email) =>
      _post('/api/auth/forgot-password', {'email': email});

  @override
  Future<void> resetPassword(String email, String code, String newPassword) =>
      _post('/api/auth/reset-password', {
        'email': email,
        'code': code,
        'newPassword': newPassword,
      });

  @override
  Future<void> logout(String refreshToken) =>
      _post('/api/auth/logout', {'refreshToken': refreshToken});

  @override
  Future<SessionUser> me() =>
      _user(() => _dio.get<Map<String, dynamic>>('/api/me'));

  @override
  Future<SessionUser> updateProfile({
    required String name,
    String? newEmail,
    String? currentPassword,
  }) => _user(
    () => _dio.put<Map<String, dynamic>>(
      '/api/me/profile',
      data: {
        'fullName': name,
        'email': ?newEmail,
        'currentPassword': ?currentPassword,
      },
    ),
  );

  @override
  Future<SessionUser> verifyNewEmail(String email, String code) => _user(
    () => _dio.post<Map<String, dynamic>>(
      '/api/me/profile/verify-email',
      data: {'email': email, 'code': code},
    ),
  );

  @override
  Future<SessionUser> setTwoFactor({
    required bool enabled,
    required String currentPassword,
  }) => _user(
    () => _dio.put<Map<String, dynamic>>(
      '/api/me/two-factor',
      data: {'enabled': enabled, 'currentPassword': currentPassword},
    ),
  );

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _dio.put<dynamic>(
        '/api/me/password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
