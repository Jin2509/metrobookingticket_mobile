import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';

/// Chip dạng pill phủ nền, không viền.
ChipThemeData metroChipTheme(
  MetroColorsExt ext,
  Color foreground,
  Color primary,
  Color onPrimary,
) => ChipThemeData(
  backgroundColor: ext.muted,
  selectedColor: primary,
  side: BorderSide.none,
  shape: const RoundedRectangleBorder(borderRadius: MetroRadius.brPill),
  labelStyle: MetroTypography.label.copyWith(
    color: WidgetStateColor.resolveWith(
      (s) => s.contains(WidgetState.selected) ? onPrimary : foreground,
    ),
  ),
  padding: const EdgeInsets.symmetric(horizontal: MetroSpacing.xxs),
);

SegmentedButtonThemeData metroSegmentedTheme(
  MetroColorsExt ext,
  Color primary,
  Color onPrimary,
) => SegmentedButtonThemeData(
  style: SegmentedButton.styleFrom(
    backgroundColor: ext.muted,
    foregroundColor: ext.mutedForeground,
    selectedBackgroundColor: primary,
    selectedForegroundColor: onPrimary,
    side: BorderSide.none,
    shape: const RoundedRectangleBorder(borderRadius: MetroRadius.brLg),
  ),
);

TabBarThemeData metroTabBarTheme(MetroColorsExt ext, Color primary) =>
    TabBarThemeData(
      dividerColor: Colors.transparent,
      labelColor: primary,
      unselectedLabelColor: ext.mutedForeground,
      indicatorColor: primary,
      labelStyle: MetroTypography.titleSmall.copyWith(fontSize: 14),
      unselectedLabelStyle: MetroTypography.body,
    );
