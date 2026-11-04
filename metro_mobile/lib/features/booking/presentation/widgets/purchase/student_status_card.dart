import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/student_providers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Lối vào "Xác nhận sinh viên" ở đầu màn mua vé, kèm trạng thái hiện tại.
class StudentStatusCard extends ConsumerWidget {
  const StudentStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentVerificationProvider).value;
    if (student == null) return const SizedBox.shrink();
    final l = context.l10n;
    final m = context.metro;
    final now = clock.now();
    final active = student.isActive(now);
    final soon = student.expiringSoon(now);
    final (subtitle, color) = switch (student.status) {
      StudentStatus.pending => (l.studentCardPending, m.accent),
      StudentStatus.rejected => (l.studentCardRejected, m.destructive),
      StudentStatus.expired => (l.studentCardExpired, m.destructive),
      StudentStatus.verified when soon => (
        l.studentRenewSoon(student.daysLeft(now)),
        m.accent,
      ),
      StudentStatus.verified when active => (
        l.studentValidUntil(dateOnly(student.expiresAt!)),
        m.success,
      ),
      _ => (l.studentCardNone, m.mutedForeground),
    };
    return Semantics(
      button: true,
      child: MetroCard(
        padding: const EdgeInsets.all(MetroSpacing.sm),
        onTap: () => context.push(Routes.pStudentVerify),
        child: Row(
          children: [
            Icon(
              active ? LucideIcons.badgeCheck : LucideIcons.graduationCap,
              color: active ? m.success : context.colors.primary,
            ),
            MetroSpacing.gapSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.studentVerifyTitle, style: context.text.titleSmall),
                  Text(
                    subtitle,
                    style: context.text.bodySmall?.copyWith(color: color),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 20, color: m.mutedForeground),
          ],
        ),
      ),
    );
  }
}
