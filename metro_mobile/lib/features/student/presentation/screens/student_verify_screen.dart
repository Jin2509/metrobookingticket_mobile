import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/presentation/controllers/student_verify_controller.dart';
import 'package:metro_mobile/features/student/presentation/widgets/student_capture_view.dart';
import 'package:metro_mobile/features/student/presentation/widgets/student_result_view.dart';
import 'package:metro_mobile/features/student/student_providers.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Xác thực sinh viên: chụp thẻ, backend đọc và đối chiếu, app hiện kết quả.
/// Trả `true` khi đã xác thực để màn trước đi tiếp.
class StudentVerifyScreen extends ConsumerWidget {
  const StudentVerifyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentVerifyProvider);
    final saved = ref.watch(studentVerificationProvider);
    final result =
        state.result ??
        (state.retaking || saved.value?.status == StudentStatus.none
            ? null
            : saved.value);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.studentVerifyTitle)),
      body: !saved.hasValue && !state.retaking
          ? const Center(child: MetroSkeleton(width: 252, height: 160))
          : result != null
          ? StudentResultView(result: result)
          : const StudentCaptureView(),
    );
  }
}
