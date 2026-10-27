import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/molecules/metro_card.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Một lối tắt: icon + nhãn ngắn.
class QuickAction {
  const QuickAction(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

/// Hàng lối tắt chia đều bề ngang (3–4 ô), các ô cao bằng nhau.
class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({required this.actions, super.key});

  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, a) in actions.indexed) ...[
            if (i > 0) MetroSpacing.gapXs,
            Expanded(
              child: MetroCard(
                onTap: a.onTap,
                padding: const EdgeInsets.symmetric(
                  vertical: MetroSpacing.sm,
                  horizontal: MetroSpacing.xxs,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(a.icon, color: Theme.of(context).colorScheme.primary),
                    MetroSpacing.gapXs,
                    Text(
                      a.label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
