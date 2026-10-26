import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/order_preview.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/booking_confirm/discount_row.dart';
import 'package:metro_mobile/features/booking/presentation/widgets/booking_confirm/loyalty_points_toggle.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Giá vé, ưu đãi, giảm theo hạng, đổi điểm, tổng thanh toán (P30).
class FareBreakdown extends StatelessWidget {
  const FareBreakdown({
    required this.preview,
    required this.usePoints,
    required this.onTogglePoints,
    super.key,
  });

  final OrderPreview preview;
  final bool usePoints;
  final VoidCallback onTogglePoints;

  @override
  Widget build(BuildContext context) {
    final p = preview;
    return MetroCard(
      child: Column(
        children: [
          DiscountRow(label: context.l10n.fare, amount: p.basePrice),
          for (final d in p.discounts)
            DiscountRow(label: d.label, amount: d.amount, negative: true),
          if (p.canUsePoints)
            LoyaltyPointsToggle(
              points: p.pointsToUse,
              value: p.pointsValue,
              available: p.pointsAvailable,
              enabled: usePoints,
              onChanged: onTogglePoints,
            ),
          const Divider(height: MetroSpacing.lg),
          DiscountRow(
            label: context.l10n.pay,
            amount: p.total(usePoints: usePoints),
            strong: true,
          ),
        ],
      ),
    );
  }
}
