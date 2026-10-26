import 'package:flutter/material.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/parking/domain/entities/parking_lot.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `Còn trống ▓▓▓▓▓░░ 312/1.200` (`parking_capacity`).
class CapacityBar extends StatelessWidget {
  const CapacityBar({required this.capacity, super.key});

  final LotCapacity? capacity;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    final c = capacity;
    if (c == null) {
      return Text(context.l10n.lotNoVehicleType, style: context.text.bodySmall);
    }
    final ratio = c.total == 0 ? 0.0 : c.free / c.total;
    final color = c.isFull
        ? m.destructive
        : (ratio < .2 ? m.accent : m.success);
    return Row(
      children: [
        Text(context.l10n.available, style: context.text.bodySmall),
        MetroSpacing.gapSm,
        Expanded(
          child: ClipRRect(
            borderRadius: MetroRadius.brPill,
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              color: color,
              backgroundColor: m.muted,
            ),
          ),
        ),
        MetroSpacing.gapSm,
        Text(
          '${count(c.free)}/${count(c.total)}',
          style: context.text.labelMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
