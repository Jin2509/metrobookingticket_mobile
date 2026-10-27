import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Phương thức thanh toán: chuyển khoản VietQR qua SePay (duy nhất).
class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final primary = context.colors.primary;
    return MetroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.paymentMethod, style: context.text.titleSmall),
          MetroSpacing.gapSm,
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: primary.withValues(alpha: .12),
                child: Icon(LucideIcons.qrCode, size: 18, color: primary),
              ),
              MetroSpacing.gapSm,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.methodVietQr, style: context.text.bodyLarge),
                    Text(l.methodVietQrHint, style: context.text.bodySmall),
                  ],
                ),
              ),
              Icon(LucideIcons.circleCheck, color: primary),
            ],
          ),
        ],
      ),
    );
  }
}
