import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/presentation/widgets/student_urgent_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Đã gửi thẻ: không bắt người dùng ở lại chờ, kết quả sẽ báo qua thông báo.
class StudentPendingView extends StatelessWidget {
  const StudentPendingView({required this.current, super.key});

  final StudentVerification current;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final submitted = current.submittedAt;
    final stillActive = current.isActive(clock.now());
    return ListView(
      padding: const EdgeInsets.all(MetroSpacing.md),
      children: [
        const Center(child: MetroMascot(size: 110)),
        MetroSpacing.gapSm,
        Text(
          l.studentPendingTitle,
          textAlign: TextAlign.center,
          style: context.text.titleLarge,
        ),
        MetroSpacing.gapXxs,
        Text(
          l.studentPendingBody,
          textAlign: TextAlign.center,
          style: context.text.bodyMedium,
        ),
        if (submitted != null) ...[
          MetroSpacing.gapXxs,
          Text(
            l.studentSubmittedAt(dateTime(submitted)),
            textAlign: TextAlign.center,
            style: context.text.bodySmall,
          ),
        ],
        if (stillActive) ...[
          MetroSpacing.gapXs,
          Text(
            l.studentStillActive(dateOnly(current.expiresAt!)),
            textAlign: TextAlign.center,
            style: context.text.labelMedium?.copyWith(
              color: context.metro.success,
            ),
          ),
        ] else ...[
          MetroSpacing.gapMd,
          const StudentUrgentCard(),
        ],
        MetroSpacing.gapMd,
        MetroButton(
          label: l.studentDone,
          expand: true,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
