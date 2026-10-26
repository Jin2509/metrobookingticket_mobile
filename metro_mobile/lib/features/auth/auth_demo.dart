/// Thông tin demo khi chạy Fake repository (BASE_URL rỗng).
abstract final class AuthDemo {
  static const password = 'Metro@123';
  static const otp = '123456';

  static const passenger = 'passenger@metro.vn';
  static const staff = 'staff@metro.vn';
  static const twoFactor = 'otp@metro.vn';
  static const admin = 'admin@metro.vn';
  static const locked = 'locked@metro.vn';

  /// Email → mô tả, hiển thị ở gợi ý màn đăng nhập.
  static const accounts = {
    passenger: 'Hành khách',
    staff: 'Nhân viên ga Thủ Đức',
    twoFactor: 'Hành khách có xác thực 2 lớp',
    admin: 'Quản trị (dùng web)',
    locked: 'Tài khoản bị khóa',
  };
}
