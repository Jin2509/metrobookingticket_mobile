import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/app/router/routes.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/booking/domain/entities/booking_request.dart';
import 'package:metro_mobile/features/booking/presentation/controllers/booking_controllers.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/student_providers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Mời sinh viên xác thực để được giảm giá ngay trên đơn. Đã xác thực thì ẩn.
class StudentOfferBanner extends ConsumerWidget {
  const StudentOfferBanner({required this.request, super.key});

  final BookingRequest request;

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    await context.push<bool>(Routes.pStudentVerify);
    ref
      ..invalidate(studentVerificationProvider)
      ..invalidate(orderPreviewProvider(request));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentVerificationProvider).value;
    if (student == null || student.isVerified) return const SizedBox.shrink();
    final l = context.l10n;
    final accent = context.metro.accent;
    return Padding(
      padding: const EdgeInsets.only(top: MetroSpacing.md),
      child: MetroCard(
        padding: const EdgeInsets.all(MetroSpacing.sm),
        onTap: () => _open(context, ref),
        child: Row(
          children: [
            Icon(LucideIcons.graduationCap, color: accent),
            MetroSpacing.gapSm,
            Expanded(
              child: Text(
                student.status == StudentStatus.pending
                    ? l.studentPending
                    : l.studentOffer,
                style: context.text.titleSmall,
              ),
            ),
            Icon(LucideIcons.chevronRight, color: accent),
          ],
        ),
      ),
    );
  }
}
