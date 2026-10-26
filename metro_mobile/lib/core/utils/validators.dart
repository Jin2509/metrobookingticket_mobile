/// Kiểm tra dữ liệu form. Trả thông điệp lỗi hoặc `null` nếu hợp lệ.
abstract final class Validators {
  static final _email = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
  static final _phone = RegExp(r'^(0|\+84)\d{9}$');

  static String? emailOrPhone(String v) {
    final s = v.trim();
    if (s.isEmpty) return 'Vui lòng nhập email hoặc số điện thoại';
    if (_email.hasMatch(s) || _phone.hasMatch(s)) return null;
    return 'Email hoặc số điện thoại không hợp lệ';
  }

  static String? email(String v) {
    final s = v.trim();
    if (s.isEmpty) return 'Vui lòng nhập email';
    return _email.hasMatch(s) ? null : 'Email không hợp lệ';
  }

  static String? required(String v, String label) =>
      v.trim().isEmpty ? 'Vui lòng nhập $label' : null;

  static String? newPassword(String v) {
    if (v.length < 8) return 'Mật khẩu tối thiểu 8 ký tự';
    if (!RegExp(r'\d').hasMatch(v) || !RegExp('[A-Za-z]').hasMatch(v)) {
      return 'Mật khẩu cần có cả chữ và số';
    }
    return null;
  }

  static String? confirm(String v, String original) =>
      v == original ? null : 'Mật khẩu nhập lại không khớp';
}

/// `tan25@gmail.com` → `t***@gmail.com`.
String maskEmail(String email) {
  final at = email.indexOf('@');
  if (at <= 1) return email;
  return '${email[0]}***${email.substring(at)}';
}
