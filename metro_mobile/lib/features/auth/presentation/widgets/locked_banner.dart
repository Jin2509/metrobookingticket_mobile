import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Banner đỏ khi 403 "Tài khoản đã bị khóa" (A1).
class LockedBanner extends StatelessWidget {
  const LockedBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final m = context.metro;
    return Container(
      margin: const EdgeInsets.only(bottom: MetroSpacing.md),
      padding: const EdgeInsets.all(MetroSpacing.sm),
      decoration: BoxDecoration(
        color: m.destructive.withValues(alpha: .1),
        borderRadius: MetroRadius.brMd,
        border: Border.all(color: m.destructive.withValues(alpha: .4)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.lock, size: 18, color: m.destructive),
          MetroSpacing.gapXs,
          Expanded(
            child: Text(
              context.l10n.lockedBanner(localizeMessage(context.l10n, message)),
              style: context.text.bodySmall?.copyWith(color: m.destructive),
            ),
          ),
        ],
      ),
    );
  }
}
