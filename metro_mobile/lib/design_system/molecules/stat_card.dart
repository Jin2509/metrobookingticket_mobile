import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/molecules/metro_card.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Nhãn + số lớn + gợi ý (điểm tích lũy, thống kê ca của staff).
class StatCard extends StatelessWidget {
  const StatCard({
    required this.label,
    required this.value,
    this.hint,
    this.icon,
    this.valueColor,
    super.key,
  });

  final String label;
  final String value;
  final String? hint;
  final IconData? icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return MetroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: context.text.labelSmall)),
              if (icon != null) Icon(icon, size: 18, color: m.mutedForeground),
            ],
          ),
          MetroSpacing.gapXxs,
          Text(
            value,
            style: context.text.headlineSmall?.copyWith(color: valueColor),
          ),
          if (hint != null) Text(hint!, style: context.text.labelSmall),
        ],
      ),
    );
  }
}
