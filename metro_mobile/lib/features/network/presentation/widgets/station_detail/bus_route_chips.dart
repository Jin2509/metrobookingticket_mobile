import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// `(01)(03)(19)` – số hiệu tuyến buýt, màu `bus`.
class BusRouteChips extends StatelessWidget {
  const BusRouteChips({required this.routes, super.key});

  final List<String> routes;

  @override
  Widget build(BuildContext context) {
    final bus = context.metro.bus;
    return Wrap(
      spacing: MetroSpacing.xxs,
      runSpacing: MetroSpacing.xxs,
      children: [
        for (final r in routes)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: bus.withValues(alpha: .15),
              borderRadius: MetroRadius.brPill,
            ),
            child: Text(
              r,
              style: context.text.labelMedium?.copyWith(color: bus),
            ),
          ),
      ],
    );
  }
}
