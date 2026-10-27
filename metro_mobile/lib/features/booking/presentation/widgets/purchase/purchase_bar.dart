import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thanh dưới P29: `Tạm tính 12.000 ₫   [Tiếp tục]`. Giá chưa trừ ưu
/// đãi; số cuối cùng hiện ở bước Xác nhận.
class PurchaseBar extends StatelessWidget {
  const PurchaseBar({required this.price, required this.onContinue, super.key});

  final int? price;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: m.card,
        border: Border(top: BorderSide(color: m.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(MetroSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.l10n.subtotal, style: context.text.bodySmall),
                    Text(
                      price == null ? '—' : money(price!),
                      style: context.text.titleLarge,
                    ),
                  ],
                ),
              ),
              MetroButton(
                label: context.l10n.continueLabel,
                size: MetroButtonSize.lg,
                onPressed: onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
