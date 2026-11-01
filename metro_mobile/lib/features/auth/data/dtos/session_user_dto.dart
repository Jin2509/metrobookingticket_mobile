import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// JSON của `GET /api/me` ↔ `SessionUser`. Bỏ qua field lạ.
abstract final class SessionUserDto {
  static SessionUser fromJson(Map<String, dynamic> json) {
    final permissions = (json['permissions'] as List<dynamic>? ?? const [])
        .cast<String>()
        .toSet();
    return SessionUser(
      id: '${json['id']}',
      name: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: Role.fromPermissions(permissions),
      permissions: permissions,
      stationName: json['stationName'] as String?,
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> toJson(SessionUser u) => {
    'id': u.id,
    'fullName': u.name,
    'email': u.email,
    'permissions': u.permissions.toList(),
    'stationName': u.stationName,
    'twoFactorEnabled': u.twoFactorEnabled,
  };
}
