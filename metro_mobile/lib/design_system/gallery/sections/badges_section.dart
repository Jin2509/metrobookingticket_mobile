import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/atoms/line_chip.dart';
import 'package:metro_mobile/design_system/atoms/metro_skeleton.dart';
import 'package:metro_mobile/design_system/atoms/money_text.dart';
import 'package:metro_mobile/design_system/atoms/status_badge.dart';
import 'package:metro_mobile/design_system/atoms/status_badge_map.dart';
import 'package:metro_mobile/design_system/gallery/gallery_sample_data.dart';
import 'package:metro_mobile/design_system/gallery/sections/gallery_section.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

class BadgesSection extends StatelessWidget {
  const BadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GallerySection(
      title: 'StatusBadge · LineChip · MoneyText · Skeleton',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: MetroSpacing.xxs,
            runSpacing: MetroSpacing.xxs,
            children: [
              for (final code in statusBadgeMap(context.l10n).keys)
                StatusBadge(status: code),
            ],
          ),
          MetroSpacing.gapSm,
          Wrap(
            spacing: MetroSpacing.xs,
            runSpacing: MetroSpacing.xs,
            children: [
              const LineChip(line: GallerySample.line1),
              const LineChip(line: GallerySample.line2),
              LineChip(line: GallerySample.line1, selected: true, onTap: () {}),
              LineChip(line: GallerySample.line2, onTap: () {}),
            ],
          ),
          MetroSpacing.gapSm,
          Row(
            children: [
              const MoneyText(16000, strikeThrough: true),
              MetroSpacing.gapXs,
              MoneyText(11160, style: context.text.titleMedium),
            ],
          ),
          MetroSpacing.gapSm,
          const MetroSkeleton(width: 220),
          MetroSpacing.gapXs,
          const MetroSkeleton(width: 140, height: 12),
        ],
      ),
    );
  }
}
