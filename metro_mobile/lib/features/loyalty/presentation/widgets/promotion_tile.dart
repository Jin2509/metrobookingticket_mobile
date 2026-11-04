import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/loyalty/domain/entities/loyalty.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `[-20%]  SV Tháng 11 · mô tả · đến 30/11`, mức giảm nổi bật bên trái.
class PromotionTile extends StatelessWidget {
  const PromotionTile({required this.promotion, super.key});

  final Promotion promotion;

  @override
  Widget build(BuildContext context) {
    final p = promotion;
    final accent = context.metro.accent;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .14),
                borderRadius: MetroRadius.brMd,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: MetroSpacing.xxs,
                  vertical: MetroSpacing.sm,
                ),
                child: Text(
                  p.discountLabel,
                  textAlign: TextAlign.center,
                  style: context.text.titleSmall?.copyWith(color: accent),
                ),
              ),
            ),
          ),
          MetroSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.title, style: context.text.titleSmall),
                Text(
                  [
                    ?p.description,
                    context.l10n.until(dateOnly(p.validUntil)),
                  ].join(' · '),
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
