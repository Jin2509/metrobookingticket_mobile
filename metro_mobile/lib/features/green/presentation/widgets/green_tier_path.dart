import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/domain/green_impact.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Chặng tiến hóa trên nền tối: bốn cấp, thanh tiến độ và số kg so với mốc.
class GreenTierPath extends StatelessWidget {
  const GreenTierPath({required this.kg, super.key});

  final double kg;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final current = GreenTier.of(kg);
    final to = current.toKg;
    final dim = context.metro.sidebarForeground.withValues(alpha: .6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final t in GreenTier.values)
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      greenTierIcon(t),
                      size: 20,
                      color: t.index <= current.index ? greenMint : dim,
                    ),
                    MetroSpacing.gapXxs,
                    Text(
                      greenTierLabel(l, t),
                      textAlign: TextAlign.center,
                      style: context.text.labelSmall?.copyWith(
                        color: t == current
                            ? MetroColors.primaryForeground
                            : dim,
                        fontWeight: t == current ? FontWeight.w700 : null,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        MetroSpacing.gapXs,
        ClipRRect(
          borderRadius: MetroRadius.brPill,
          child: LinearProgressIndicator(
            value: greenHealth(kg),
            minHeight: 8,
            color: greenMint,
            backgroundColor: MetroColors.primaryForeground.withValues(
              alpha: .16,
            ),
          ),
        ),
        if (to != null) ...[
          MetroSpacing.gapXxs,
          Text(
            l.greenTierProgress(greenNumber(kg), greenNumber(to)),
            textAlign: TextAlign.end,
            style: context.text.labelSmall?.copyWith(
              color: context.metro.sidebarForeground,
            ),
          ),
        ],
      ],
    );
  }
}
