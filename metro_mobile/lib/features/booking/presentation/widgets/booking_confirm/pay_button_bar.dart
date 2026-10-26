import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thanh dưới cùng: `[ Thanh toán bằng QR · 11.160 ₫ ]`.
class PayButtonBar extends StatelessWidget {
  const PayButtonBar({
    required this.total,
    required this.loading,
    required this.onPay,
    this.error,
    super.key,
  });

  final int total;
  final bool loading;
  final VoidCallback? onPay;
  final String? error;

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: MetroSpacing.xs),
                  child: Text(
                    error!,
                    style: context.text.bodySmall?.copyWith(
                      color: m.destructive,
                    ),
                  ),
                ),
              MetroButton(
                label: context.l10n.payByQr(money(total)),
                icon: LucideIcons.qrCode,
                size: MetroButtonSize.lg,
                expand: true,
                loading: loading,
                onPressed: onPay,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
