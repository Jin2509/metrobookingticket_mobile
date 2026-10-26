import 'package:flutter/material.dart';
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
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final MetroButtonVariant actionVariant;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Padding(
      padding: const EdgeInsets.all(MetroSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: m.muted, shape: BoxShape.circle),
            child: Icon(icon, size: 32, color: m.mutedForeground),
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
