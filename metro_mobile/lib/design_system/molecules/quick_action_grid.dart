import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/radius.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Một lối tắt: icon + nhãn ngắn.
class QuickAction {
  const QuickAction(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

/// Hàng lối tắt chia đều bề ngang: ô icon nền nhạt và nhãn ngắn bên dưới.
class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({required this.actions, super.key});

  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final a in actions)
          Expanded(
            child: Semantics(
              button: true,
              label: a.label,
              excludeSemantics: true,
              child: InkWell(
                onTap: a.onTap,
                borderRadius: MetroRadius.brLg,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: MetroSpacing.xxs,
                  ),
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.metro.secondary,
                          borderRadius: MetroRadius.brXl,
                        ),
                        child: SizedBox.square(
                          dimension: 56,
                          child: Icon(a.icon, color: context.colors.primary),
                        ),
                      ),
                      MetroSpacing.gapXs,
                      Text(
                        a.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: context.text.labelMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
