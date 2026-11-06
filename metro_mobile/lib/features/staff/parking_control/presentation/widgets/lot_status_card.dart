import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/parking_control/presentation/controllers/parking_control_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Sức chứa từng loại xe: số chỗ trống và thanh đầy, sắp hết chỗ thì đổi màu.
class LotStatusCard extends ConsumerWidget {
  const LotStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lot = ref.watch(lotStatusProvider).value;
    if (lot == null) return const MetroSkeleton(height: 96);
    final l = context.l10n;
    final m = context.metro;
    return MetroCard(
      child: Column(
        children: [
          for (final (i, (v, used, total)) in lot.usage.indexed) ...[
            if (i > 0) MetroSpacing.gapSm,
            Row(
              children: [
                Expanded(
                  child: Text(
                    vehicleCodeLabel(l, v),
                    style: context.text.titleSmall,
                  ),
                ),
                Text(
                  l.lotFree(count(total - used)),
                  style: context.text.labelMedium,
                ),
                MetroSpacing.gapXs,
                Text(
                  '${count(used)}/${count(total)}',
                  style: context.text.titleSmall,
                ),
              ],
            ),
            MetroSpacing.gapXxs,
            ClipRRect(
              borderRadius: MetroRadius.brPill,
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : used / total,
                minHeight: 8,
                backgroundColor: m.muted,
                color: total > 0 && used / total >= .9
                    ? m.destructive
                    : total > 0 && used / total >= .7
                    ? m.accent
                    : m.success,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
