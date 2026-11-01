import 'package:flutter/foundation.dart';
import 'package:metro_mobile/features/auth/domain/entities/role.dart';

/// Người dùng đang đăng nhập. Router, theme, bottom nav đều đọc từ đây.
@immutable
class SessionUser {
  const SessionUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.permissions = const {},
    this.stationName,
    this.twoFactorEnabled = false,
  });

  final String id;
  final String name;
  final String email;
  final Role role;

  /// Quyền hiện tại, dùng để ẩn/hiện chức năng.
  final Set<String> permissions;

  /// Ga được phân công (chỉ Staff, UC2-03).
  final String? stationName;

  /// Đăng nhập cần thêm mã gửi qua email.
  final bool twoFactorEnabled;

  @override
  bool operator ==(Object other) =>
      other is SessionUser &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.role == role &&
      other.twoFactorEnabled == twoFactorEnabled &&
      setEquals(other.permissions, permissions);

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    role,
    twoFactorEnabled,
    Object.hashAllUnordered(permissions),
  );
}
