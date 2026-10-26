import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/tokens/colors.dart';

/// Token màu ngoài `ColorScheme` của Material (success, bus, accent,
/// sidebar*...). Đọc qua `context.metro`.
@immutable
class MetroColorsExt extends ThemeExtension<MetroColorsExt> {
  const MetroColorsExt({
    required this.card,
    required this.border,
    required this.muted,
    required this.mutedForeground,
    required this.secondary,
    required this.accent,
    required this.accentForeground,
    required this.success,
    required this.destructive,
    required this.bus,
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarPrimary,
    required this.sidebarAccent,
  });

  static const light = MetroColorsExt(
    card: MetroColors.card,
    border: MetroColors.border,
    muted: MetroColors.muted,
    mutedForeground: MetroColors.mutedForeground,
    secondary: MetroColors.secondary,
    accent: MetroColors.accent,
    accentForeground: MetroColors.accentForeground,
    success: MetroColors.success,
    destructive: MetroColors.destructive,
    bus: MetroColors.bus,
    sidebar: MetroColors.sidebar,
    sidebarForeground: MetroColors.sidebarForeground,
    sidebarPrimary: MetroColors.sidebarPrimary,
    sidebarAccent: MetroColors.sidebarAccent,
  );

  static const dark = MetroColorsExt(
    card: MetroColors.darkCard,
    border: MetroColors.darkBorder,
    muted: MetroColors.darkMuted,
    mutedForeground: MetroColors.darkMutedForeground,
    secondary: MetroColors.darkSecondary,
    accent: MetroColors.accent,
    accentForeground: Color(0xFFFFC58F),
    success: Color(0xFF3CC46B),
    destructive: MetroColors.darkDestructive,
    bus: MetroColors.bus,
    sidebar: MetroColors.sidebar,
    sidebarForeground: MetroColors.sidebarForeground,
    sidebarPrimary: MetroColors.sidebarPrimary,
    sidebarAccent: MetroColors.sidebarAccent,
  );

  /// Staff: nền navy, tương phản cao khi quét QR ngoài trời (mục 3.2).
  static const staff = MetroColorsExt(
    card: MetroColors.sidebarAccent,
    border: Color(0xFF223D58),
    muted: MetroColors.sidebarAccent,
    mutedForeground: Color(0xFF8FA6B8),
    secondary: Color(0xFF1B3550),
    accent: MetroColors.accent,
    accentForeground: Color(0xFFFFC58F),
    success: Color(0xFF3CC46B),
    destructive: MetroColors.darkDestructive,
    bus: MetroColors.bus,
    sidebar: MetroColors.sidebar,
    sidebarForeground: MetroColors.sidebarForeground,
    sidebarPrimary: MetroColors.sidebarPrimary,
    sidebarAccent: MetroColors.sidebarAccent,
  );

  final Color card;
  final Color border;
  final Color muted;
  final Color mutedForeground;
  final Color secondary;
  final Color accent;
  final Color accentForeground;
  final Color success;
  final Color destructive;
  final Color bus;
  final Color sidebar;
  final Color sidebarForeground;
  final Color sidebarPrimary;
  final Color sidebarAccent;

  @override
  MetroColorsExt copyWith() => this;

  @override
  MetroColorsExt lerp(MetroColorsExt? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return MetroColorsExt(
      card: l(card, other.card),
      border: l(border, other.border),
      muted: l(muted, other.muted),
      mutedForeground: l(mutedForeground, other.mutedForeground),
      secondary: l(secondary, other.secondary),
      accent: l(accent, other.accent),
      accentForeground: l(accentForeground, other.accentForeground),
      success: l(success, other.success),
      destructive: l(destructive, other.destructive),
      bus: l(bus, other.bus),
      sidebar: l(sidebar, other.sidebar),
      sidebarForeground: l(sidebarForeground, other.sidebarForeground),
      sidebarPrimary: l(sidebarPrimary, other.sidebarPrimary),
      sidebarAccent: l(sidebarAccent, other.sidebarAccent),
    );
  }
}

extension MetroThemeX on BuildContext {
  MetroColorsExt get metro =>
      Theme.of(this).extension<MetroColorsExt>() ?? MetroColorsExt.light;

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get text => Theme.of(this).textTheme;
}
