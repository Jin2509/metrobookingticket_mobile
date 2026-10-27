import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/atoms/metro_button.dart';
import 'package:metro_mobile/design_system/molecules/countdown_chip.dart';
import 'package:metro_mobile/design_system/molecules/metro_card.dart';
import 'package:metro_mobile/design_system/organisms/payment_qr/payment_qr_code.dart';
import 'package:metro_mobile/design_system/organisms/payment_qr/payment_qr_parts.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// QR thanh toán chung (vé, gửi xe): mã VietQR + đếm ngược 10:00, số
/// tiền, mã đơn, [details] (chuyển khoản thủ công), trạng thái chờ, nút
/// hủy (P32). Chỉ nhận props.
class PaymentQrSheet extends StatelessWidget {
  const PaymentQrSheet({
    required this.qrData,
    required this.amount,
    required this.orderCode,
    required this.timeLeft,
    required this.expired,
    required this.onExpired,
    required this.onRenew,
    required this.onCancel,
    this.cancelling = false,
    this.details,
    super.key,
  });

  final String qrData;
  final int amount;
  final String orderCode;
  final Duration timeLeft;
  final bool expired;
  final VoidCallback onExpired;
  final VoidCallback onRenew;
  final VoidCallback onCancel;
  final bool cancelling;
  final Widget? details;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final muted = context.text.bodySmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MetroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l.scanVietQr, style: context.text.titleSmall),
                  ),
                  if (expired)
                    Text(l.codeExpired, style: muted)
                  else
                    CountdownChip(
                      key: ValueKey(orderCode + timeLeft.inSeconds.toString()),
                      duration: timeLeft,
                      onExpired: onExpired,
                    ),
                ],
              ),
              MetroSpacing.gapSm,
              Center(
                child: PaymentQrCode(
                  data: qrData,
                  expired: expired,
                  onRenew: onRenew,
                ),
              ),
              MetroSpacing.gapXs,
              Text(
                l.paymentScanHint,
                textAlign: TextAlign.center,
                style: muted,
              ),
              MetroSpacing.gapSm,
              PaymentInfoRow(
                label: l.amount,
                value: money(amount),
                strong: true,
              ),
              PaymentInfoRow(label: l.orderCode, value: orderCode),
            ],
          ),
        ),
        if (details != null) ...[MetroSpacing.gapSm, details!],
        MetroSpacing.gapMd,
        if (!expired) const PaymentWaiting(),
        MetroSpacing.gapMd,
        MetroButton(
          label: l.cancelTransaction,
          variant: MetroButtonVariant.outline,
          expand: true,
          loading: cancelling,
          onPressed: onCancel,
        ),
      ],
    );
  }
}
