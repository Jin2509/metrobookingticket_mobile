/// Thông tin demo khi chạy Fake source (BASE_URL rỗng).
abstract final class AuthDemo {
  static const password = 'Metro@123';
  static const otp = '123456';

  static const passenger = 'passenger@metro.vn';
  static const twoFactor = '2fa@metro.vn';
  static const staff = 'staff@metro.vn';
  static const unverified = 'pending@metro.vn';
  static const admin = 'admin@metro.vn';
  static const locked = 'locked@metro.vn';

  /// Email → mô tả, hiển thị ở gợi ý màn đăng nhập.
  static const accounts = {
    passenger: 'Hành khách',
    twoFactor: 'Hành khách đã bật xác nhận 2 lớp',
    staff: 'Nhân viên ga Thủ Đức',
    unverified: 'Hành khách chưa xác thực email',
    admin: 'Quản trị (dùng web)',
    locked: 'Tài khoản bị khóa',
  };
}
