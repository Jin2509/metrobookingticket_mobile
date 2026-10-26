import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/loyalty/loyalty_providers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `(Hạng Bạc · 820 điểm ▸)` → P53.
class MemberChip extends ConsumerWidget {
  const MemberChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(memberSummaryProvider).value;
    if (s == null) return const SizedBox(height: MetroSpacing.minTouch);
    final accent = context.metro.accent;
    // Chip cao ~26dp; vùng chạm mở rộng lên 48dp theo chiều dọc.
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.push(Routes.pLoyalty),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: MetroSpacing.minTouch),
          child: Align(
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .14),
                borderRadius: MetroRadius.brPill,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.award, size: 14, color: accent),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.memberChip(s.tierName, count(s.points)),
                      style: context.text.labelMedium?.copyWith(
                        color: context.metro.accentForeground,
                      ),
                    ),
                    Icon(LucideIcons.chevronRight, size: 14, color: accent),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
