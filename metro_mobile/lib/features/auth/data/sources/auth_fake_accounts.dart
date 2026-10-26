import 'package:metro_mobile/features/auth/auth_demo.dart';

/// Tài khoản demo khi BASE_URL rỗng, mật khẩu chung `AuthDemo.password`.

class FakeAccount {
  FakeAccount({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.password = AuthDemo.password,
    this.stationName,
    this.requires2fa = false,
    this.locked = false,
  });

  final String id;
  final String email;
  final String name;
  final String role;
  String password;
  final String? stationName;
  final bool requires2fa;
  final bool locked;

  Map<String, dynamic> toUserJson() => {
    'id': id,
    'fullName': name,
    'email': email,
    'role': role,
    'stationName': stationName,
  };
}

List<FakeAccount> seedFakeAccounts() => [
  FakeAccount(
    id: 'u-passenger',
    email: AuthDemo.passenger,
    name: 'Minh Anh',
    role: 'PASSENGER',
  ),
  FakeAccount(
    id: 'u-staff',
    email: AuthDemo.staff,
    name: 'Nhân viên Thủ Đức',
    role: 'STAFF_STATION',
    stationName: 'Ga Thủ Đức',
  ),
  FakeAccount(
    id: 'u-2fa',
    email: AuthDemo.twoFactor,
    name: 'Hành khách 2FA',
    role: 'PASSENGER',
    requires2fa: true,
  ),
  FakeAccount(
    id: 'u-admin',
    email: AuthDemo.admin,
    name: 'Quản trị viên',
    role: 'ADMIN',
  ),
  FakeAccount(
    id: 'u-locked',
    email: AuthDemo.locked,
    name: 'Tài khoản bị khóa',
    role: 'PASSENGER',
    locked: true,
  ),
];
