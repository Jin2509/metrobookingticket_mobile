import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// Một dòng `Nhãn ............ 16.000 ₫`; [negative] hiện `-3.200 ₫`.
class DiscountRow extends StatelessWidget {
  const DiscountRow({
    required this.label,
    required this.amount,
    this.negative = false,
    this.strong = false,
    super.key,
  });

  final String label;
  final int amount;
  final bool negative;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong ? context.text.titleMedium : context.text.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xxs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(
            negative ? '-${money(amount)}' : money(amount),
            style: style?.copyWith(
              color: negative ? context.metro.success : null,
            ),
          ),
        ],
      ),
    );
  }
}
