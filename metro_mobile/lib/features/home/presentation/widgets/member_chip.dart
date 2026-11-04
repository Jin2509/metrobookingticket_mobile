import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/money_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/green/presentation/controllers/green_controller.dart';
import 'package:metro_mobile/features/green/presentation/widgets/green_format.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// `(Cây xanh · 635 CPoint ▸)` → Hành trình xanh.
class MemberChip extends ConsumerWidget {
  const MemberChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(greenSummaryProvider).value;
    if (s == null) return const SizedBox(height: MetroSpacing.minTouch);
    final accent = context.metro.accent;
    // Chip cao ~26dp; vùng chạm mở rộng lên 48dp theo chiều dọc.
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.push(Routes.pGreen),
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
                      context.l10n.memberChip(
                        greenTierLabel(context.l10n, s.tier),
                        count(s.cpoint),
                      ),
                      style: context.text.labelMedium?.copyWith(
                        color: const Color(0xFFFFC58F),
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
