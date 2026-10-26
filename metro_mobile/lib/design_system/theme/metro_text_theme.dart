import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/tokens/typography.dart';

/// Map thang chữ mục 3.4 vào `TextTheme` của Material.
TextTheme metroTextTheme(Color foreground, Color mutedForeground) {
  return TextTheme(
    displaySmall: MetroTypography.display.copyWith(color: foreground),
    headlineSmall: MetroTypography.stat.copyWith(color: foreground),
    titleLarge: MetroTypography.title.copyWith(color: foreground),
    titleMedium: MetroTypography.titleSmall.copyWith(color: foreground),
    titleSmall: MetroTypography.titleSmall.copyWith(color: foreground),
    bodyLarge: MetroTypography.body.copyWith(color: foreground),
    bodyMedium: MetroTypography.body.copyWith(color: foreground),
    bodySmall: MetroTypography.label.copyWith(color: mutedForeground),
    labelLarge: MetroTypography.body.copyWith(
      color: foreground,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: MetroTypography.label.copyWith(color: foreground),
    labelSmall: MetroTypography.label.copyWith(color: mutedForeground),
  );
}
