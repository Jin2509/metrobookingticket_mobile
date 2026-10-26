import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/models/notification_kind.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Một thông báo: icon theo loại, chấm "chưa đọc", thời gian (P60).
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.kind,
    required this.title,
    required this.timeLabel,
    this.body,
    this.unread = false,
    this.onTap,
    super.key,
  });

  final NotificationKind kind;
  final String title;
  final String? body;
  final String timeLabel;
  final bool unread;
  final VoidCallback? onTap;

  Color _tint(BuildContext context) {
    final m = context.metro;
    return switch (kind) {
      NotificationKind.payment => m.success,
      NotificationKind.operation => m.destructive,
      NotificationKind.promotion || NotificationKind.ticketExpiry => m.accent,
      _ => context.colors.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final tint = _tint(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        color: unread ? context.colors.primary.withValues(alpha: .05) : null,
        padding: const EdgeInsets.all(MetroSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(MetroSpacing.xs),
              decoration: BoxDecoration(
                color: tint.withValues(alpha: .12),
                borderRadius: MetroRadius.brMd,
              ),
              child: Icon(kind.icon, size: 20, color: tint),
            ),
            MetroSpacing.gapSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.text.bodyMedium?.copyWith(
                      fontWeight: unread ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (body != null) Text(body!, style: context.text.bodySmall),
                ],
              ),
            ),
            MetroSpacing.gapXs,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeLabel, style: context.text.labelSmall),
                if (unread) ...[
                  MetroSpacing.gapXxs,
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: m.destructive,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
