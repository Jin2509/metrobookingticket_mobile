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
    this.stationName,
  });

  final String id;
  final String name;
  final String email;
  final Role role;

  /// Ga được phân công (chỉ Staff, UC2-03).
  final String? stationName;

  @override
  bool operator ==(Object other) =>
      other is SessionUser &&
      other.id == id &&
      other.email == email &&
      other.role == role;

  @override
  int get hashCode => Object.hash(id, email, role);
}
