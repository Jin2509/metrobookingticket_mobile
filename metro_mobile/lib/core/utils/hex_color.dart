import 'dart:ui';

/// `#E2231A` / `E2231A` → `Color`. Màu tuyến luôn đọc từ API (mục 3.3).
Color colorFromHex(String hex, {Color fallback = const Color(0xFF576574)}) {
  final value = hex.replaceFirst('#', '').trim();
  if (value.length != 6) return fallback;
  final parsed = int.tryParse(value, radix: 16);
  return parsed == null ? fallback : Color(0xFF000000 | parsed);
}
