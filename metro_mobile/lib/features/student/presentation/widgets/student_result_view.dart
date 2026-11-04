import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/presentation/controllers/student_verify_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Kết quả xác thực: Futu báo trạng thái, thông tin đọc được và bước tiếp theo.
class StudentResultView extends ConsumerWidget {
  const StudentResultView({required this.result, super.key});

  final StudentVerification result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final r = result;
    final (title, mood) = switch (r.status) {
      StudentStatus.verified => (l.studentVerified, MascotMood.happy),
      StudentStatus.pending => (l.studentPending, MascotMood.normal),
      _ => (l.studentRejected, MascotMood.worried),
    };
    final ctrl = ref.read(studentVerifyProvider.notifier);
    return ListView(
      padding: const EdgeInsets.all(MetroSpacing.md),
      children: [
        Center(
          child: MetroMascot(size: 110, mood: mood, celebrate: r.isVerified),
        ),
        MetroSpacing.gapSm,
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.text.titleLarge,
        ),
        if (r.isVerified) ...[
          MetroSpacing.gapXxs,
          Text(
            l.studentVerifiedBody,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium,
          ),
        ],
        if (r.reason != null) ...[
          MetroSpacing.gapXxs,
          Text(
            r.reason!,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium,
          ),
        ],
        if (r.fullName != null) ...[
          MetroSpacing.gapMd,
          MetroCard(
            child: Column(
              children: [
                _Row(l.studentFieldName, r.fullName),
                _Row(l.studentFieldSchool, r.school),
                _Row(l.studentFieldCode, r.studentCode),
                if (r.validUntil != null)
                  _Row(l.studentFieldValid, dateOnly(r.validUntil!)),
              ],
            ),
          ),
        ],
        MetroSpacing.gapLg,
        if (r.isVerified)
          MetroButton(
            label: l.continueLabel,
            expand: true,
            onPressed: () => context.pop(true),
          )
        else ...[
          MetroButton(
            label: l.studentRetake,
            expand: true,
            variant: r.status == StudentStatus.pending
                ? MetroButtonVariant.outline
                : MetroButtonVariant.primary,
            onPressed: ctrl.retake,
          ),
          if (r.status == StudentStatus.pending) ...[
            MetroSpacing.gapXs,
            MetroButton(
              label: l.studentBack,
              expand: true,
              onPressed: () => context.pop(false),
            ),
          ],
        ],
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: MetroSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: context.text.bodySmall)),
          MetroSpacing.gapSm,
          Expanded(
            flex: 2,
            child: Text(
              value ?? '',
              textAlign: TextAlign.end,
              style: context.text.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
