import 'package:flutter/material.dart';
import 'package:metro_mobile/design_system/organisms/mascot/metro_mascot.dart';
import 'package:metro_mobile/design_system/atoms/metro_button.dart';
import 'package:metro_mobile/design_system/theme/metro_colors_ext.dart';
import 'package:metro_mobile/design_system/tokens/spacing.dart';

/// Trạng thái rỗng + hành động gợi ý (VD "Bạn chưa có vé nào").
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.actionVariant = MetroButtonVariant.primary,
    this.mood = MascotMood.normal,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final MetroButtonVariant actionVariant;
  final MascotMood mood;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Padding(
      padding: const EdgeInsets.all(MetroSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                MetroMascot(size: 88, mood: mood),
                Positioned(
                  right: -6,
                  top: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: m.muted,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(MetroSpacing.xxs),
                      child: Icon(icon, size: 18, color: m.mutedForeground),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MetroSpacing.gapMd,
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.text.titleMedium,
          ),
          if (message != null) ...[
            MetroSpacing.gapXxs,
            Text(
              message!,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: m.mutedForeground,
              ),
            ),
          ],
          if (actionLabel != null) ...[
            MetroSpacing.gapMd,
            MetroButton(
              label: actionLabel!,
              onPressed: onAction,
              variant: actionVariant,
            ),
          ],
        ],
      ),
    );
  }
}
