import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/loyalty/domain/entities/loyalty.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `SV Tháng 11 · -20% · đến 30/11`.
class PromotionTile extends StatelessWidget {
  const PromotionTile({required this.promotion, super.key});

  final Promotion promotion;

  @override
  Widget build(BuildContext context) {
    final p = promotion;
    final accent = context.metro.accent;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(LucideIcons.badgePercent, color: accent),
      title: Text(p.title, style: context.text.bodyLarge),
      subtitle: Text(
        [?p.description, context.l10n.until(dateOnly(p.validUntil))].join('\n'),
        style: context.text.bodySmall,
      ),
      trailing: Text(
        p.discountLabel,
        style: context.text.titleSmall?.copyWith(color: accent),
      ),
    );
  }
}
