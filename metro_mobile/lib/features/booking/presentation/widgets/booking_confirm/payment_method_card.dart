import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Phương thức thanh toán: chuyển khoản VietQR qua SePay. Bản dev có thêm
/// "Thanh toán giả" (khi [onMockChanged] khác null) để thử luồng mua vé
/// mà không cần cấu hình SePay.
class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    this.mockSelected = false,
    this.onMockChanged,
    super.key,
  });

  final bool mockSelected;
  final ValueChanged<bool>? onMockChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final choose = onMockChanged;
    return MetroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.paymentMethod, style: context.text.titleSmall),
          MetroSpacing.gapSm,
          _Option(
            icon: LucideIcons.qrCode,
            title: l.methodVietQr,
            hint: l.methodVietQrHint,
            selected: choose == null || !mockSelected,
            onTap: choose == null ? null : () => choose(false),
          ),
          if (choose != null) ...[
            MetroSpacing.gapSm,
            _Option(
              icon: LucideIcons.flaskConical,
              title: l.methodMock,
              hint: l.methodMockHint,
              selected: mockSelected,
              onTap: () => choose(true),
            ),
          ],
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.title,
    required this.hint,
    required this.selected,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String hint;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final row = Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: primary.withValues(alpha: .12),
          child: Icon(icon, size: 18, color: primary),
        ),
        MetroSpacing.gapSm,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.text.bodyLarge),
              Text(hint, style: context.text.bodySmall),
            ],
          ),
        ),
        Icon(
          selected ? LucideIcons.circleCheck : LucideIcons.circle,
          color: selected ? primary : context.colors.outline,
        ),
      ],
    );
    if (onTap == null) return row;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: MetroRadius.brPill,
        child: row,
      ),
    );
  }
}
