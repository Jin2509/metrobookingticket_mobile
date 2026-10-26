import 'package:flutter/widgets.dart';

/// Lưới 4pt, lề màn hình 16 (mục 3.4).
abstract final class MetroSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  /// Lề trái/phải chuẩn của màn hình.
  static const double screen = md;

  /// Vùng chạm tối thiểu (Material).
  static const double minTouch = 48;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screen,
  );

  static const SizedBox gapXxs = SizedBox(width: xxs, height: xxs);
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);
}
