import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';

/// Hiển thị tiền `12.000 ₫`. `strikeThrough` cho giá gốc trước ưu đãi.
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.amount, {
    this.style,
    this.strikeThrough = false,
    super.key,
  });

  final num amount;
  final TextStyle? style;
  final bool strikeThrough;

  @override
  Widget build(BuildContext context) {
    final base = style ?? context.text.bodyMedium;
    return Text(
      money(amount),
      style: strikeThrough
          ? base?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: context.metro.mutedForeground,
            )
          : base,
    );
  }
}
