import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Bo góc và lưới khoảng cách 4pt (mục 3.4).
class ShapeTokensSection extends StatelessWidget {
  const ShapeTokensSection({super.key});

  static const Map<String, double> _radii = {
    'sm 8': MetroRadius.sm,
    'md 10': MetroRadius.md,
    'lg 12': MetroRadius.lg,
    'xl 16': MetroRadius.xl,
    '2xl 20': MetroRadius.xxl,
  };

  static const List<double> _spaces = [
    MetroSpacing.xxs,
    MetroSpacing.xs,
    MetroSpacing.sm,
    MetroSpacing.md,
    MetroSpacing.lg,
    MetroSpacing.xl,
  ];

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final primary = context.colors.primary;
    return GallerySection(
      title: 'Bo góc & khoảng cách',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: MetroSpacing.sm,
            children: [
              for (final e in _radii.entries)
                Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: m.secondary,
                        border: Border.all(color: primary),
                        borderRadius: BorderRadius.circular(e.value),
                      ),
                    ),
                    Text(e.key, style: context.text.labelSmall),
                  ],
                ),
            ],
          ),
          MetroSpacing.gapMd,
          for (final s in _spaces)
            Padding(
              padding: const EdgeInsets.only(bottom: MetroSpacing.xxs),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text('${s.toInt()}', style: context.text.labelSmall),
                  ),
                  Container(width: s * 4, height: 8, color: m.accent),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
