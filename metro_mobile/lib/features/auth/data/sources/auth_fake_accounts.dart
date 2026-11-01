import 'package:metro_mobile/features/auth/auth_demo.dart';

/// Tài khoản demo khi BASE_URL rỗng, mật khẩu chung `AuthDemo.password`.

const _passengerPermissions = ['TICKET_BUY', 'TICKET_VIEW_OWN'];
const _staffPermissions = [
  'TICKET_VALIDATE',
  'TICKET_VIEW_ALL',
  'TICKET_VIEW_OWN',
];
const _adminPermissions = [
  ..._passengerPermissions,
  'TICKET_VALIDATE',
  'TICKET_VIEW_ALL',
  'STATION_MANAGE',
  'REPORT_VIEW',
  'USER_VIEW',
  'USER_MANAGE',
  'RBAC_MANAGE',
];

class FakeAccount {
  FakeAccount({
    required this.id,
    required this.email,
    required this.name,
    this.permissions = _passengerPermissions,
    this.password = AuthDemo.password,
    this.stationName,
    this.verified = true,
    this.locked = false,
    this.twoFactorEnabled = false,
  });

  final String id;
  String email;
  String name;
  final List<String> permissions;
  String password;
  final String? stationName;
  bool verified;
  final bool locked;
  bool twoFactorEnabled;

  /// Đổi email chờ xác nhận OTP.
  String? pendingEmail;

  /// Cùng định dạng `GET /api/me`.
  Map<String, dynamic> toUserJson() => {
    'id': id,
    'fullName': name,
    'email': email,
    'permissions': permissions,
    'stationName': stationName,
    'twoFactorEnabled': twoFactorEnabled,
  };
}

List<FakeAccount> seedFakeAccounts() => [
  FakeAccount(id: 'u-passenger', email: AuthDemo.passenger, name: 'Minh Anh'),
  FakeAccount(
    id: 'u-two-factor',
    email: AuthDemo.twoFactor,
    name: 'Hành khách bảo mật',
    twoFactorEnabled: true,
  ),
  FakeAccount(
    id: 'u-staff',
    email: AuthDemo.staff,
    name: 'Nhân viên Thủ Đức',
    permissions: _staffPermissions,
    stationName: 'Ga Thủ Đức',
  ),
  FakeAccount(
    id: 'u-unverified',
    email: AuthDemo.unverified,
    name: 'Hành khách mới',
    verified: false,
  ),
  FakeAccount(
    id: 'u-admin',
    email: AuthDemo.admin,
    name: 'Quản trị viên',
    permissions: _adminPermissions,
  ),
  FakeAccount(
    id: 'u-locked',
    email: AuthDemo.locked,
    name: 'Tài khoản bị khóa',
    locked: true,
  ),
];
