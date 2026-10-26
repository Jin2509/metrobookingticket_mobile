/// Vai trò lấy từ phản hồi đăng nhập/JWT (mục 6.2). App không cho chọn.
enum Role {
  passenger,
  staffStation,

  /// ADMIN, MANAGER, ACCOUNTANT: dùng trang quản trị web.
  other;

  static Role fromBackend(String value) => switch (value.toUpperCase()) {
    'PASSENGER' => Role.passenger,
    'STAFF_STATION' => Role.staffStation,
    _ => Role.other,
  };

  String get backendValue => switch (this) {
    Role.passenger => 'PASSENGER',
    Role.staffStation => 'STAFF_STATION',
    Role.other => 'OTHER',
  };
}
