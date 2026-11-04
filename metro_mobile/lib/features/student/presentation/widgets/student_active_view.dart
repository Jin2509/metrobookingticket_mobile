import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/core/utils/date_formatter.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/presentation/controllers/student_verify_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Đã xác nhận: quyền lợi, thông tin thẻ, thời hạn. Sắp hết hạn thì mời gửi lại
/// sớm để không gián đoạn ưu đãi.
class StudentActiveView extends ConsumerWidget {
  const StudentActiveView({required this.current, super.key});

  final StudentVerification current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = context.metro;
    final now = clock.now();
    final soon = current.expiringSoon(now);
    return ListView(
      padding: const EdgeInsets.all(MetroSpacing.md),
      children: [
        Center(
          child: MetroMascot(
            size: 96,
            mood: soon ? MascotMood.normal : MascotMood.happy,
          ),
        ),
        MetroSpacing.gapSm,
        Text(
          l.studentVerified,
          textAlign: TextAlign.center,
          style: context.text.titleLarge,
        ),
        Text(
          l.studentValidUntil(dateOnly(current.expiresAt!)),
          textAlign: TextAlign.center,
          style: context.text.titleSmall?.copyWith(
            color: soon ? m.accent : m.success,
          ),
        ),
        MetroSpacing.gapMd,
        MetroCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Benefit(l.studentBenefitSingle),
              _Benefit(l.studentBenefitMonth),
              const Divider(height: MetroSpacing.lg),
              _Info(l.studentFieldName, current.fullName),
              _Info(l.studentFieldSchool, current.school),
              _Info(l.studentFieldCode, current.studentCode),
            ],
          ),
        ),
        MetroSpacing.gapSm,
        Text(
          soon ? l.studentRenewSoon(current.daysLeft(now)) : l.studentRenewNote,
          textAlign: TextAlign.center,
          style: context.text.bodySmall?.copyWith(
            color: soon ? m.accent : null,
          ),
        ),
        MetroSpacing.gapMd,
        if (soon) ...[
          MetroButton(
            label: l.studentRenew,
            expand: true,
            onPressed: ref.read(studentVerifyProvider.notifier).renew,
          ),
          MetroSpacing.gapXs,
        ],
        MetroButton(
          label: l.buyTicket,
          icon: LucideIcons.ticketPlus,
          expand: true,
          variant: soon
              ? MetroButtonVariant.outline
              : MetroButtonVariant.primary,
          onPressed: () => context.push(Routes.buy()),
        ),
      ],
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MetroSpacing.xxs),
      child: Row(
        children: [
          Icon(LucideIcons.check, size: 18, color: context.metro.success),
          MetroSpacing.gapXs,
          Expanded(child: Text(text, style: context.text.bodyMedium)),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.label, this.value);

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
