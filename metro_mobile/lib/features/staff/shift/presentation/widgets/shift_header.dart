import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/staff/shift/presentation/controllers/shift_providers.dart';

/// `📍 Ga Thủ Đức · Ca 06:00–14:00` (S00). [showLot]: hiện bãi xe.
class ShiftHeader extends ConsumerWidget {
  const ShiftHeader({this.showLot = false, super.key});

  final bool showLot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(shiftProvider).value;
    if (s == null) return const MetroSkeleton(width: 220, height: 20);
    final label = showLot
        ? s.lotName
        : 'Ga ${s.stationName} · Ca ${s.shiftLabel}';
    return Row(
      children: [
        Icon(LucideIcons.mapPin, size: 18, color: context.colors.primary),
        MetroSpacing.gapXs,
        Expanded(child: Text(label, style: context.text.titleMedium)),
      ],
    );
  }
}
