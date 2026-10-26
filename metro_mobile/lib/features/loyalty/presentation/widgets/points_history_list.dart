import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/loyalty/domain/entities/loyalty.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `+16  Vé lượt BT→TĐ   20/10` / `−100 Đổi điểm  18/10`.
class PointsHistoryList extends StatelessWidget {
  const PointsHistoryList({required this.entries, super.key});

  final List<PointsEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Text(context.l10n.noPointsHistory, style: context.text.bodySmall);
    }
    final m = context.metro;
    return Column(
      children: [
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xxs),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Text(
                    e.delta > 0 ? '+${e.delta}' : '−${-e.delta}',
                    style: context.text.titleSmall?.copyWith(
                      color: e.delta > 0 ? m.success : m.destructive,
                    ),
                  ),
                ),
                Expanded(child: Text(e.title, style: context.text.bodyMedium)),
                Text(dateOnly(e.createdAt), style: context.text.labelSmall),
              ],
            ),
          ),
      ],
    );
  }
}
