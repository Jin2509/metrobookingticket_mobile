import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/gallery/sections/color_swatch_tile.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Toàn bộ màu của theme hiện tại (mục 3.1, 3.2).
class ColorTokensSection extends StatelessWidget {
  const ColorTokensSection({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final c = context.colors;
    final swatches = <String, Color>{
      'background': Theme.of(context).scaffoldBackgroundColor,
      'foreground': c.onSurface,
      'card': m.card,
      'primary': c.primary,
      'onPrimary': c.onPrimary,
      'secondary': m.secondary,
      'muted': m.muted,
      'mutedFg': m.mutedForeground,
      'accent': m.accent,
      'destructive': m.destructive,
      'success': m.success,
      'bus': m.bus,
      'border': m.border,
      'sidebar': m.sidebar,
      'sidebarPrimary': m.sidebarPrimary,
      'sidebarAccent': m.sidebarAccent,
    };
    return GallerySection(
      title: 'Màu',
      child: Wrap(
        spacing: MetroSpacing.sm,
        runSpacing: MetroSpacing.sm,
        children: [
          for (final e in swatches.entries)
            ColorSwatchTile(name: e.key, color: e.value),
        ],
      ),
    );
  }
}
