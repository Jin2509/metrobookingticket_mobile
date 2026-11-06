import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Một lượt quét: mã vé hoặc biển số, kết quả, giờ, chiều vào/ra. Không có
/// thông tin cá nhân của hành khách.
class ScanLogTile extends StatelessWidget {
  const ScanLogTile({required this.entry, super.key});

  final ScanLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final e = entry;
    final m = context.metro;
    final icon = e.parking
        ? LucideIcons.circleParking
        : (e.valid ? LucideIcons.circleCheck : LucideIcons.octagonX);
    final color = e.valid ? m.success : m.destructive;
    return Padding(
      padding: const EdgeInsets.only(bottom: MetroSpacing.xs),
      child: MetroCard(
        padding: const EdgeInsets.all(MetroSpacing.sm),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: .16),
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(
                dimension: 40,
                child: Icon(icon, size: 20, color: color),
              ),
            ),
            MetroSpacing.gapSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.code, style: context.text.titleSmall),
                  Text(
                    localizeMessage(context.l10n, e.label),
                    style: context.text.bodySmall?.copyWith(
                      color: e.valid ? null : m.destructive,
                    ),
                  ),
                ],
              ),
            ),
            MetroSpacing.gapXs,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeOnly(e.at), style: context.text.labelMedium),
                Text(
                  e.entry ? context.l10n.inShort : context.l10n.outShort,
                  style: context.text.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
