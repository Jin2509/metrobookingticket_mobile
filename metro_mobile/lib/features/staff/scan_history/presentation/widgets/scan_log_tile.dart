import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/scan_history/domain/entities/scan_log_entry.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `10:41 ✅ Vào  VE-80021  Vé lượt` – chỉ mã vé/biển số.
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
      padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(timeOnly(e.at), style: context.text.labelMedium),
          ),
          Icon(icon, size: 18, color: color),
          MetroSpacing.gapXs,
          SizedBox(
            width: 32,
            child: Text(
              e.entry ? context.l10n.inShort : context.l10n.outShort,
              style: context.text.labelMedium,
            ),
          ),
          Expanded(
            child: Text(
              e.code,
              style: context.text.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Text(
              localizeMessage(context.l10n, e.label),
              textAlign: TextAlign.end,
              style: context.text.labelSmall?.copyWith(
                color: e.valid ? null : m.destructive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
