import 'package:metro_mobile/features/auth/domain/entities/role.dart';
import 'package:metro_mobile/features/auth/domain/entities/session_user.dart';

/// JSON ↔ `SessionUser`.
abstract final class SessionUserDto {
  static SessionUser fromJson(Map<String, dynamic> json) => SessionUser(
    id: '${json['id']}',
    name: json['fullName'] as String? ?? json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    role: Role.fromBackend(json['role'] as String? ?? ''),
    stationName: json['stationName'] as String?,
  );

  static Map<String, dynamic> toJson(SessionUser u) => {
    'id': u.id,
    'fullName': u.name,
    'email': u.email,
    'role': u.role.backendValue,
    'stationName': u.stationName,
  };
}
