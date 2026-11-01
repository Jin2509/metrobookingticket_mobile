/// Shell của app, suy từ `permissions` của `GET /api/me` (không dựa vào tên vai
/// trò vì admin có thể tạo vai trò mới). App không cho chọn.
enum Role {
  passenger,
  staffStation,

  /// Quyền quản trị hoặc không đủ quyền: dùng trang quản trị web.
  other;

  static const _adminPermissions = {
    'STATION_MANAGE',
    'REPORT_VIEW',
    'USER_VIEW',
    'USER_MANAGE',
    'RBAC_MANAGE',
  };

  static Role fromPermissions(Set<String> permissions) {
    if (permissions.any(_adminPermissions.contains)) return Role.other;
    if (permissions.contains('TICKET_VALIDATE')) return Role.staffStation;
    if (permissions.contains('TICKET_BUY')) return Role.passenger;
    return Role.other;
  }
}
