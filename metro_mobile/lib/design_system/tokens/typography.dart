import 'package:flutter/painting.dart';

/// Thang chữ Be Vietnam Pro (mục 3.4).
///
/// Chỉ định kích thước và độ đậm. Màu chữ do theme gán.
abstract final class MetroTypography {
  static const fontFamily = 'BeVietnamPro';

  static const display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.18,
    letterSpacing: -.6,
  );

  static const title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 21,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -.3,
  );

  static const titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );

  /// Ứng với `StatCard` trên web (text-2xl bold).
  static const stat = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -.4,
  );
}
