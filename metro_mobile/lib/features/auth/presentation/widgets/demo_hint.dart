import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// Gợi ý dữ liệu demo, chỉ hiện khi chạy Fake source của auth.
class DemoHint extends StatelessWidget {
  const DemoHint({required this.lines, super.key});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    if (!Env.useFakeAuth) return const SizedBox.shrink();
    final m = context.metro;
    return Container(
      margin: const EdgeInsets.only(top: MetroSpacing.md),
      padding: const EdgeInsets.all(MetroSpacing.sm),
      decoration: BoxDecoration(
        color: m.secondary,
        borderRadius: MetroRadius.brMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.info, size: 16, color: context.colors.primary),
          MetroSpacing.gapXs,
          Expanded(
            child: Text(lines.join('\n'), style: context.text.labelSmall),
          ),
        ],
      ),
    );
  }
}
