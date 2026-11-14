import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/student/domain/entities/student_verification.dart';
import 'package:metro_mobile/features/student/presentation/controllers/student_verify_controller.dart';
import 'package:metro_mobile/features/student/presentation/widgets/student_declaration_fields.dart';
import 'package:metro_mobile/features/student/presentation/widgets/student_urgent_card.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Chụp thẻ để gửi duyệt: lý do gửi lại (nếu có), khung ảnh, thông tin tự
/// khai, đồng ý gửi ảnh, thời gian chờ và lối đi gấp.
class StudentCaptureView extends ConsumerWidget {
  const StudentCaptureView({required this.current, super.key});

  final StudentVerification current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = context.metro;
    final s = ref.watch(studentVerifyProvider);
    final ctrl = ref.read(studentVerifyProvider.notifier);
    final image = s.image;
    final error = s.pickFailed ? l.studentPickFailed : s.error;
    return ListView(
      padding: const EdgeInsets.all(MetroSpacing.md),
      children: [
        if (current.reason != null) ...[
          MascotTip(text: current.reason!, mood: MascotMood.worried),
          MetroSpacing.gapSm,
        ],
        MascotTip(text: l.studentTip),
        MetroSpacing.gapMd,
        ClipRRect(
          borderRadius: MetroRadius.brXl,
          child: AspectRatio(
            aspectRatio: 1.6,
            child: image != null
                ? Image.memory(image, fit: BoxFit.cover, cacheWidth: 900)
                : ColoredBox(
                    color: m.muted,
                    child: Icon(
                      LucideIcons.idCard,
                      size: 56,
                      color: m.mutedForeground,
                    ),
                  ),
          ),
        ),
        MetroSpacing.gapSm,
        Row(
          children: [
            Expanded(
              child: MetroButton(
                label: image == null ? l.studentTakePhoto : l.studentRetake,
                icon: LucideIcons.camera,
                variant: MetroButtonVariant.outline,
                expand: true,
                onPressed: s.submitting
                    ? null
                    : () => ctrl.pick(ImageSource.camera),
              ),
            ),
            MetroSpacing.gapSm,
            Expanded(
              child: MetroButton(
                label: l.studentChoosePhoto,
                icon: LucideIcons.image,
                variant: MetroButtonVariant.outline,
                expand: true,
                onPressed: s.submitting
                    ? null
                    : () => ctrl.pick(ImageSource.gallery),
              ),
            ),
          ],
        ),
        MetroSpacing.gapMd,
        const StudentDeclarationFields(),
        MetroSpacing.gapSm,
        CheckboxListTile(
          value: s.consent,
          onChanged: s.submitting
              ? null
              : (v) => ctrl.setConsent(value: v ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: Text(l.studentConsent, style: context.text.bodySmall),
        ),
        if (error != null) ...[
          Text(
            error,
            style: context.text.bodySmall?.copyWith(color: m.destructive),
          ),
          MetroSpacing.gapXs,
        ],
        MetroButton(
          label: l.studentCheck,
          expand: true,
          loading: s.submitting,
          onPressed: s.canSubmit ? ctrl.submit : null,
        ),
        MetroSpacing.gapMd,
        const StudentUrgentCard(),
      ],
    );
  }
}
