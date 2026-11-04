import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Cách tính thu gọn mặc định, mở ra khi người dùng muốn xem.
class GreenMethodCard extends StatelessWidget {
  const GreenMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return MetroCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(l.greenMethodTitle, style: context.text.titleSmall),
          // App không đóng gói font Material Icons: icon mặc định sẽ hiện sai
          // ký tự, có máy ra chữ giống chữ Hán.
          trailing: const Icon(LucideIcons.chevronDown, size: 20),
          childrenPadding: const EdgeInsets.fromLTRB(
            MetroSpacing.md,
            0,
            MetroSpacing.md,
            MetroSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.greenFormula, style: context.text.labelLarge),
            MetroSpacing.gapXxs,
            Text(l.greenFactors, style: context.text.bodySmall),
            MetroSpacing.gapXxs,
            Text(l.greenDisclaimer, style: context.text.bodySmall),
          ],
        ),
      ),
    );
  }
}
