import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';

/// Một dòng cài đặt. Loại bắt buộc bị khóa kèm biểu tượng ổ khóa.
class PrefSwitchTile extends StatelessWidget {
  const PrefSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.locked = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final bool locked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: locked ? null : onChanged,
      title: Row(
        children: [
          Flexible(child: Text(title, style: context.text.bodyLarge)),
          if (locked) ...[
            MetroSpacing.gapXxs,
            Icon(
              LucideIcons.lock,
              size: 14,
              color: context.metro.mutedForeground,
            ),
          ],
        ],
      ),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, style: context.text.bodySmall),
    );
  }
}
