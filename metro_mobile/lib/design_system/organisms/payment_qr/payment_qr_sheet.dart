import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/atoms/metro_button.dart';
import 'package:metro_mobile/design_system/molecules/countdown_chip.dart';
import 'package:metro_mobile/design_system/organisms/payment_qr/payment_qr_code.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// QR thanh toán chung (vé, gửi xe): đếm ngược 10:00, số tiền, mã đơn,
/// trạng thái chờ, nút hủy (P32). Chỉ nhận props.
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

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final muted = context.text.bodySmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: expired
              ? Text(l.codeExpired, style: muted)
              : CountdownChip(
                  key: ValueKey(orderCode + timeLeft.inSeconds.toString()),
                  duration: timeLeft,
                  onExpired: onExpired,
                ),
        ),
        MetroSpacing.gapSm,
        Center(
          child: PaymentQrCode(
            data: qrData,
            expired: expired,
            onRenew: onRenew,
          ),
        ),
        MetroSpacing.gapMd,
        Text(l.paymentScanHint, textAlign: TextAlign.center, style: muted),
        MetroSpacing.gapMd,
        _InfoRow(label: l.amount, value: money(amount), strong: true),
        _InfoRow(label: l.orderCode, value: orderCode),
        MetroSpacing.gapMd,
        if (!expired) const _Waiting(),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
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

class _Waiting extends StatelessWidget {
  const _Waiting();

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
