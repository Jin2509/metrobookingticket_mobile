import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/shift/presentation/controllers/shift_providers.dart';
import 'package:metro_mobile/features/staff/shift/presentation/widgets/shift_header.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Phân công của nhân viên ở tab Tài khoản: ga, ca, bãi xe, số người tại ga.
class StaffAssignmentCard extends ConsumerWidget {
  const StaffAssignmentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(shiftProvider).value;
    if (s == null) return const MetroSkeleton(height: 120);
    final l = context.l10n;
    final staff = staffCountLabel(l, s);
    return SectionCard(
      title: l.menuStation,
      child: Column(
        children: [
          _Row(l.staffFieldStation, l.stationName(s.stationName)),
          _Row(l.staffFieldShift, s.shiftLabel),
          _Row(l.staffFieldLot, s.lotName),
          if (staff != null) _Row(l.staffFieldTeam, staff),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: context.text.bodySmall)),
          MetroSpacing.gapSm,
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.text.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
