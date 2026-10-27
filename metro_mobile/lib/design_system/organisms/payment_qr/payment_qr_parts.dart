import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Số tiền ........ 9.120 ₫`.
class PaymentInfoRow extends StatelessWidget {
  const PaymentInfoRow({
    required this.label,
    required this.value,
    super.key,
    this.strong = false,
  });
  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong ? context.text.titleMedium : context.text.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xxs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: context.text.bodySmall)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

/// Vòng quay + "Đang chờ xác nhận thanh toán…".
class PaymentWaiting extends StatelessWidget {
  const PaymentWaiting({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox.square(
          dimension: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: context.colors.primary,
          ),
        ),
        MetroSpacing.gapXs,
        Flexible(
          child: Text(
            context.l10n.paymentWaiting,
            style: context.text.bodyMedium,
          ),
        ),
      ],
    );
  }
}
