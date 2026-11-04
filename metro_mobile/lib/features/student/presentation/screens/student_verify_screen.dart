import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/presentation/controllers/student_verify_controller.dart';
import 'package:metro_mobile/features/student/presentation/widgets/student_active_view.dart';
import 'package:metro_mobile/features/student/presentation/widgets/student_capture_view.dart';
import 'package:metro_mobile/features/student/presentation/widgets/student_pending_view.dart';
import 'package:metro_mobile/features/student/student_providers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Xác nhận sinh viên: chức năng riêng, làm trước khi cần đặt vé. Chưa có hoặc
/// cần gửi lại thì chụp thẻ; đã gửi thì chờ duyệt; đã duyệt thì xem hiệu lực.
class StudentVerifyScreen extends ConsumerWidget {
  const StudentVerifyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renewing = ref.watch(studentVerifyProvider.select((s) => s.renewing));
    final saved = ref.watch(studentVerificationProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.studentVerifyTitle)),
      body: saved == null
          ? const Center(child: MetroSkeleton(width: 252, height: 160))
          : renewing
          ? StudentCaptureView(current: saved)
          : switch (saved.status) {
              StudentStatus.pending => StudentPendingView(current: saved),
              StudentStatus.verified when saved.isActive(clock.now()) =>
                StudentActiveView(current: saved),
              _ => StudentCaptureView(current: saved),
            },
    );
  }
}
