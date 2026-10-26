import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';

enum MetroButtonVariant { primary, secondary, outline, ghost, destructive }

enum MetroButtonSize {
  sm(40, 12, 14),
  md(48, 16, 14),
  lg(56, 24, 16);

  MetroButtonSize(this.height, this.paddingX, this.fontSize);
  final double height;
  final double paddingX;
  final double fontSize;
}

/// Màu nền / chữ / viền theo variant, giống `ui/button.tsx` trên web.
({Color bg, Color fg, Color? border}) resolveButtonColors(
  BuildContext context,
  MetroButtonVariant variant,
) {
  final c = context.colors;
  final m = context.metro;
  return switch (variant) {
    MetroButtonVariant.primary => (
      bg: c.primary,
      fg: c.onPrimary,
      border: null,
    ),
    MetroButtonVariant.secondary => (
      bg: m.secondary,
      fg: c.onSurface,
      border: null,
    ),
    MetroButtonVariant.outline => (
      bg: Colors.transparent,
      fg: c.onSurface,
      border: m.border,
    ),
    MetroButtonVariant.ghost => (
      bg: Colors.transparent,
      fg: c.primary,
      border: null,
    ),
    MetroButtonVariant.destructive => (
      bg: m.destructive,
      fg: c.onError,
      border: null,
    ),
  };
}
