import 'package:flutter/painting.dart';

/// Bảng màu gốc, quy đổi từ `src/styles.css` của web (mục 3.1–3.3).
///
/// Widget không đọc trực tiếp lớp này. Màu đi qua `ThemeData` và
/// `MetroColorsExt` để đổi được theo theme (light, dark, staff).
abstract final class MetroColors {
  // Light (Passenger, mặc định)
  static const background = Color(0xFFF3F8FA);
  static const foreground = Color(0xFF0B1C2C);
  static const card = Color(0xFFFFFFFF);

  /// Web dùng `#00878F` (4,3:1 trên nền trắng). Mobile đậm hơn để chữ
  /// nhỏ đạt WCAG AA ≥ 4,5:1 trên mọi nền sáng (mục 10.2).
  static const primary = Color(0xFF00767E);
  static const primaryForeground = Color(0xFFFCFCFC);
  static const secondary = Color(0xFFDDEFF5);
  static const muted = Color(0xFFE8F0F4);
  static const mutedForeground = Color(0xFF576574);
  static const accent = Color(0xFFF3821D);
  static const accentForeground = Color(0xFF7A3A00);

  /// Web `#E7000B`; đậm hơn để chữ trắng trên badge đỏ đạt ≥ 4,5:1.
  static const destructive = Color(0xFFD6000A);

  /// Web `#25984D` (3,7:1); đậm hơn để chữ xanh đạt ≥ 4,5:1.
  static const success = Color(0xFF1B7A3D);
  static const bus = Color(0xFF4EA739);
  static const border = Color(0xFFD5E0E6);

  /// Bóng đổ nhẹ cho sheet/nút nổi trên bản đồ.
  static const shadow = Color(0x22000000);

  // Thương hiệu tối (Staff Shell, màn Auth)
  static const sidebar = Color(0xFF06192C);
  static const sidebarForeground = Color(0xFFCBDAE2);
  static const sidebarPrimary = Color(0xFF00BEC7);
  static const sidebarAccent = Color(0xFF142A41);

  // Dark (Passenger), giống `.dark` trên web
  static const darkBackground = Color(0xFF020618);
  static const darkCard = Color(0xFF0F172B);
  static const darkForeground = Color(0xFFF8FAFC);
  static const darkMuted = Color(0xFF1D293D);
  static const darkMutedForeground = Color(0xFF90A1B9);
  static const darkDestructive = Color(0xFFFF6467);
  static const darkBorder = Color(0xFF1D293D);
  static const darkSecondary = Color(0xFF1D293D);
}
