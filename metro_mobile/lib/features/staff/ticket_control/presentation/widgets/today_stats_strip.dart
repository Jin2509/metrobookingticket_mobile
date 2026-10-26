import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/shift/presentation/controllers/shift_providers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Hôm nay: 412 vào · 389 ra · 7 từ chối`.
class TodayStatsStrip extends ConsumerWidget {
  const TodayStatsStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(shiftStatsProvider).value;
    final m = context.metro;
    final l = context.l10n;
    Widget stat(String label, int? v, Color color) => Expanded(
      child: Column(
        children: [
          Text(
            v == null ? '—' : count(v),
            style: context.text.headlineSmall?.copyWith(color: color),
          ),
          Text(label, style: context.text.labelSmall),
        ],
      ),
    );
    return MetroCard(
      child: Row(
        children: [
          stat(l.statEntries, s?.entries, context.colors.primary),
          stat(l.statExits, s?.exits, m.success),
          stat(l.statRejected, s?.rejected, m.destructive),
        ],
      ),
    );
  }
}
