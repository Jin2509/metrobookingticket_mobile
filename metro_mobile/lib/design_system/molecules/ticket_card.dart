import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/atoms/metro_button.dart';
import 'package:metro_mobile/design_system/atoms/status_badge.dart';
import 'package:metro_mobile/design_system/molecules/metro_card.dart';
import 'package:metro_mobile/design_system/molecules/route_label.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Thẻ vé: loại vé, hành trình, hạn dùng, trạng thái, nút "Mở QR" (P40).
class TicketCard extends StatelessWidget {
  const TicketCard({
    required this.title,
    required this.status,
    required this.validUntil,
    this.from,
    this.to,
    this.onOpenQr,
    super.key,
  });

  final String title;
  final String status;
  final DateTime validUntil;

  /// Vé ngày/tháng không có ga đi/đến.
  final String? from;
  final String? to;
  final VoidCallback? onOpenQr;

  static const _usable = {'PAID', 'IN_USE'};

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final usable = _usable.contains(status);
    return MetroCard(
      onTap: onOpenQr,
      child: Row(
        children: [
          Icon(LucideIcons.ticket, color: context.colors.primary),
          MetroSpacing.gapSm,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.titleSmall),
                if (from != null && to != null)
                  RouteLabel(
                    from: from!,
                    to: to!,
                    style: context.text.bodyMedium,
                  ),
                Text(
                  context.l10n.validUntilShort(dateTime(validUntil)),
                  style: context.text.labelSmall?.copyWith(
                    color: m.mutedForeground,
                  ),
                ),
                MetroSpacing.gapXxs,
                StatusBadge(status: status),
              ],
            ),
          ),
          MetroButton(
            label: usable ? context.l10n.openQr : context.l10n.details,
            icon: usable ? LucideIcons.qrCode : null,
            size: MetroButtonSize.sm,
            variant: usable
                ? MetroButtonVariant.primary
                : MetroButtonVariant.ghost,
            onPressed: onOpenQr,
          ),
        ],
      ),
    );
  }
}
