import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Thang chữ mục 3.4, kèm văn bản tiếng Việt để kiểm tra dấu.
class TypographySection extends StatelessWidget {
  const TypographySection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    final samples = <String, TextStyle?>{
      'display 28/700': t.displaySmall,
      'stat 24/700': t.headlineSmall,
      'title 20/600': t.titleLarge,
      'titleSmall 16/600': t.titleMedium,
      'body 14/400': t.bodyMedium,
      'label 12/500': t.labelMedium,
    };
    return GallerySection(
      title: 'Typography · Be Vietnam Pro',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final e in samples.entries) ...[
            Text(e.key, style: t.labelSmall),
            Text('Ga Bến Thành – Suối Tiên', style: e.value),
            MetroSpacing.gapXs,
          ],
        ],
      ),
    );
  }
}
