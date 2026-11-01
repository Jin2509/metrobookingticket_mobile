import 'dart:convert';

/// Kiểm tra dữ liệu form. Trả thông điệp lỗi hoặc `null` nếu hợp lệ.
abstract final class Validators {
  static final _email = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
  static final _otp = RegExp(r'^\d{6}$');

  static const _maxEmail = 320;
  static const _maxFullName = 120;
  static const _maxPasswordBytes = 72;

  static String? email(String v) {
    final s = v.trim();
    if (s.isEmpty) return 'Vui lòng nhập email';
    return _email.hasMatch(s) && s.length <= _maxEmail
        ? null
        : 'Email không hợp lệ';
  }

  static String? required(String v, String label) =>
      v.trim().isEmpty ? 'Vui lòng nhập $label' : null;

  static String? fullName(String v) {
    final s = v.trim();
    if (s.isEmpty) return 'Vui lòng nhập họ tên';
    return s.length <= _maxFullName ? null : 'Họ tên tối đa 120 ký tự';
  }

  /// Backend giới hạn theo byte UTF-8: ký tự có dấu chiếm nhiều byte.
  static String? newPassword(String v) {
    if (v.length < 8) return 'Mật khẩu tối thiểu 8 ký tự';
    if (utf8.encode(v).length > _maxPasswordBytes) return 'Mật khẩu quá dài';
    if (v.trim().isEmpty) return 'Mật khẩu không được toàn khoảng trắng';
    return null;
  }

  static String? otp(String v) =>
      _otp.hasMatch(v) ? null : 'Mã OTP gồm 6 chữ số';

  static String? confirm(String v, String original) =>
      v == original ? null : 'Mật khẩu nhập lại không khớp';
}

/// `tan25@gmail.com` → `t***@gmail.com`.
String maskEmail(String email) {
  final at = email.indexOf('@');
  if (at <= 1) return email;
  return '${email[0]}***${email.substring(at)}';
}
