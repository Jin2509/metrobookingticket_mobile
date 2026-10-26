import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/theme/metro_text_theme.dart';
import 'package:metro_mobile/design_system/tokens/colors.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';

/// Ba theme của app (mục 3): light/dark cho Passenger, staff cho Staff
/// Shell và màn Auth.
abstract final class MetroTheme {
  static final ThemeData light = _build(
    brightness: Brightness.light,
    background: MetroColors.background,
    foreground: MetroColors.foreground,
    primary: MetroColors.primary,
    onPrimary: MetroColors.primaryForeground,
    ext: MetroColorsExt.light,
  );

  static final ThemeData dark = _build(
    brightness: Brightness.dark,
    background: MetroColors.darkBackground,
    foreground: MetroColors.darkForeground,
    primary: MetroColors.sidebarPrimary,
    onPrimary: MetroColors.sidebar,
    ext: MetroColorsExt.dark,
  );

  static final ThemeData staff = _build(
    brightness: Brightness.dark,
    background: MetroColors.sidebar,
    foreground: MetroColors.sidebarForeground,
    primary: MetroColors.sidebarPrimary,
    onPrimary: MetroColors.sidebar,
    ext: MetroColorsExt.staff,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color foreground,
    required Color primary,
    required Color onPrimary,
    required MetroColorsExt ext,
  }) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: ext.secondary,
      onSecondary: foreground,
      tertiary: ext.accent,
      onTertiary: MetroColors.primaryForeground,
      error: ext.destructive,
      onError: MetroColors.primaryForeground,
      surface: ext.card,
      onSurface: foreground,
      onSurfaceVariant: ext.mutedForeground,
      surfaceContainerHighest: ext.muted,
      outline: ext.border,
      outlineVariant: ext.border,
    );
    final border = OutlineInputBorder(
      borderRadius: MetroRadius.brLg,
      borderSide: BorderSide(color: ext.border),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: MetroTypography.fontFamily,
      scaffoldBackgroundColor: background,
      textTheme: metroTextTheme(foreground, ext.mutedForeground),
      extensions: [ext],
      dividerTheme: DividerThemeData(color: ext.border, thickness: 1),
      // Không dùng icon hệ thống: thay icon mặc định bằng Lucide.
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (_) => const Icon(LucideIcons.arrowLeft),
        closeButtonIconBuilder: (_) => const Icon(LucideIcons.x),
        drawerButtonIconBuilder: (_) => const Icon(LucideIcons.menu),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: MetroTypography.titleSmall.copyWith(color: foreground),
      ),
      cardTheme: CardThemeData(
        color: ext.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: MetroRadius.brLg,
          side: BorderSide(color: ext.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ext.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: MetroSpacing.md,
          vertical: MetroSpacing.sm,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: ext.destructive),
        ),
        hintStyle: MetroTypography.body.copyWith(color: ext.mutedForeground),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ext.card,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MetroRadius.xxl),
          ),
        ),
      ),
      // Vùng chạm tối thiểu 48dp (cả nút trên AppBar).
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, MetroSpacing.minTouch),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: MetroRadius.brLg),
        contentTextStyle: MetroTypography.body.copyWith(
          color: MetroColors.primaryForeground,
        ),
      ),
    );
  }
}
