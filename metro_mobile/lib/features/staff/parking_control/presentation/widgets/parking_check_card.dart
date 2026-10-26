import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/parking_control/presentation/controllers/parking_control_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Kết quả quét gần nhất: `(Chưa gửi) → (Đang gửi) ✓` hoặc lỗi 409.
class ParkingCheckCard extends ConsumerWidget {
  const ParkingCheckCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(parkingControlProvider);
    final m = context.metro;
    if (s.error != null) {
      return MetroCard(
        child: Row(
          children: [
            Icon(LucideIcons.octagonX, color: m.destructive),
            MetroSpacing.gapSm,
            Expanded(
              child: Text(
                localizeMessage(context.l10n, s.error!),
                style: context.text.bodyLarge,
              ),
            ),
          ],
        ),
      );
    }
    final c = s.check;
    if (c == null) return const SizedBox.shrink();
    return SectionCard(
      title: context.l10n.result,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(c.plate, style: context.text.titleMedium),
          MetroSpacing.gapXs,
          Row(
            children: [
              StatusBadge(status: c.fromStatus),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: MetroSpacing.xs),
                child: Icon(LucideIcons.arrowRight, size: 16),
              ),
              StatusBadge(status: c.toStatus),
              MetroSpacing.gapXs,
              Icon(LucideIcons.circleCheck, color: m.success, size: 18),
            ],
          ),
          MetroSpacing.gapXs,
          Text(
            c.isEntry
                ? context.l10n.parkedInAt(timeOnly(c.at))
                : context.l10n.parkedOutAt(timeOnly(c.at)),
            style: context.text.bodySmall,
          ),
        ],
      ),
    );
  }
}
