import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Token + phiên lưu trong `flutter_secure_storage` (P5).
class SecureStore {
  SecureStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _access = 'access_token';
  static const _refresh = 'refresh_token';
  static const _session = 'session_user';

  // Phiên không "Ghi nhớ đăng nhập" chỉ giữ trong bộ nhớ.
  String? _memAccess;
  String? _memRefresh;

  Future<String?> get accessToken async =>
      _memAccess ?? await _storage.read(key: _access);

  Future<String?> get refreshToken async =>
      _memRefresh ?? await _storage.read(key: _refresh);

  Future<String?> get sessionJson => _storage.read(key: _session);

  Future<void> saveTokens({
    required String access,
    required String refresh,
    bool persist = true,
  }) async {
    _memAccess = access;
    _memRefresh = refresh;
    if (persist) {
      await _storage.write(key: _access, value: access);
      await _storage.write(key: _refresh, value: refresh);
    }
  }

  Future<void> saveSession(String json) =>
      _storage.write(key: _session, value: json);

  /// Đăng xuất: xóa sạch token và phiên.
  Future<void> clear() async {
    _memAccess = null;
    _memRefresh = null;
    await _storage.deleteAll();
  }
}
