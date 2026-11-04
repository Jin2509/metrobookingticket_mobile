import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Hiện khi chọn vé HSSV mà chưa được xác nhận: nói rõ lý do và lối đi tiếp,
/// không để nút Tiếp tục bị khóa mà không giải thích.
class StudentTicketNotice extends StatelessWidget {
  const StudentTicketNotice({
    required this.status,
    required this.onUseDayTicket,
    super.key,
  });

  final StudentStatus status;
  final VoidCallback onUseDayTicket;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pending = status == StudentStatus.pending;
    return MetroCard(
      padding: const EdgeInsets.all(MetroSpacing.sm),
      color: context.metro.accent.withValues(alpha: .1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            pending ? l.studentNoticePending : l.studentNoticeNeeded,
            style: context.text.bodyMedium,
          ),
          MetroSpacing.gapXs,
          Row(
            children: [
              if (!pending) ...[
                Expanded(
                  child: MetroButton(
                    label: l.studentConfirmAction,
                    expand: true,
                    size: MetroButtonSize.sm,
                    onPressed: () => context.push(Routes.pStudentVerify),
                  ),
                ),
                MetroSpacing.gapXs,
              ],
              Expanded(
                child: MetroButton(
                  label: l.studentUseDay,
                  expand: true,
                  size: MetroButtonSize.sm,
                  variant: MetroButtonVariant.outline,
                  onPressed: onUseDayTicket,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
