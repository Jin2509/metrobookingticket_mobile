import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/parking_control/presentation/controllers/parking_control_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Sức chứa: Xe máy 640/800 · Ô tô 41/60`.
class LotStatusCard extends ConsumerWidget {
  const LotStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lot = ref.watch(lotStatusProvider).value;
    if (lot == null) return const MetroSkeleton(height: 56);
    return MetroCard(
      child: Row(
        children: [
          for (final (v, used, total) in lot.usage)
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${count(used)}/${count(total)}',
                    style: context.text.titleMedium,
                  ),
                  Text(
                    vehicleCodeLabel(context.l10n, v),
                    style: context.text.labelSmall,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
