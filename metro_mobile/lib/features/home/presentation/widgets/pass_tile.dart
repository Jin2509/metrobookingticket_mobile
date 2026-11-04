import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// Một ô dọc trong lưới vé: loại vé, nội dung chính và hành động ở đáy ô.
/// Cần chiều cao có giới hạn vì hành động được đẩy xuống đáy.
class PassTile extends StatelessWidget {
  const PassTile({
    required this.icon,
    required this.label,
    required this.title,
    required this.action,
    required this.onTap,
    this.subtitle,
    this.status,
    this.moreCount = 0,
    super.key,
  });

  final IconData icon;
  final String label;
  final String title;
  final String action;
  final VoidCallback onTap;
  final String? subtitle;

  /// Mã trạng thái cho `StatusBadge`.
  final String? status;

  /// Số vé cùng loại chưa hiện, xem đủ ở tab Vé.
  final int moreCount;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return Semantics(
      button: true,
      child: MetroCard(
        padding: const EdgeInsets.all(MetroSpacing.sm),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.metro.secondary,
                    borderRadius: MetroRadius.brLg,
                  ),
                  child: SizedBox.square(
                    dimension: 40,
                    child: Icon(icon, color: primary),
                  ),
                ),
                const Spacer(),
                if (moreCount > 0)
                  Text('+$moreCount', style: context.text.labelMedium),
              ],
            ),
            MetroSpacing.gapSm,
            Text(label, style: context.text.labelSmall),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.text.titleSmall,
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodySmall,
              ),
            if (status != null) ...[
              MetroSpacing.gapXxs,
              StatusBadge(status: status!),
            ],
            MetroSpacing.gapSm,
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    action,
                    style: context.text.labelMedium?.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(LucideIcons.chevronRight, size: 16, color: primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
