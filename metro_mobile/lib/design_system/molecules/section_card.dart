import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/molecules/metro_card.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Card có tiêu đề + hành động bên phải, ứng với `Section` trên web.
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.title,
    required this.child,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return MetroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: context.text.labelMedium?.copyWith(
                    color: context.metro.mutedForeground,
                    letterSpacing: .6,
                  ),
                ),
              ),
              if (actionLabel != null)
                TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ),
          MetroSpacing.gapSm,
          child,
        ],
      ),
    );
  }
}
