import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Khung tiêu đề + nội dung cho từng mục trong gallery.
class GallerySection extends StatelessWidget {
  const GallerySection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        MetroSpacing.md,
        MetroSpacing.lg,
        MetroSpacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: context.text.labelSmall),
          MetroSpacing.gapSm,
          child,
        ],
      ),
    );
  }
}
