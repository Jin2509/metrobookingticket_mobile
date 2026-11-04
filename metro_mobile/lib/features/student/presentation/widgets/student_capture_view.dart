import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:metro_mobile/core/config/env.dart';
import 'package:metro_mobile/core/di/core_providers.dart';
import 'package:metro_mobile/design_system/design_system.dart';
import 'package:metro_mobile/features/student/presentation/controllers/student_verify_controller.dart';
import 'package:metro_mobile/l10n/l10n.dart';

/// Bước chụp thẻ: khung ảnh, đồng ý gửi ảnh, nút kiểm tra.
class StudentCaptureView extends ConsumerWidget {
  const StudentCaptureView({super.key});

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
        MascotTip(text: s.submitting ? l.studentChecking : l.studentTip),
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
        if (Env.useFakeData) ...[const _DemoOutcome(), MetroSpacing.gapXs],
        MetroButton(
          label: l.studentCheck,
          expand: true,
          loading: s.submitting,
          onPressed: image != null && s.consent ? ctrl.submit : null,
        ),
      ],
    );
  }
}

/// Chỉ có khi dùng dữ liệu giả: chọn kết quả để xem đủ các trạng thái.
class _DemoOutcome extends ConsumerStatefulWidget {
  const _DemoOutcome();

  @override
  ConsumerState<_DemoOutcome> createState() => _DemoOutcomeState();
}

class _DemoOutcomeState extends ConsumerState<_DemoOutcome> {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ledger = ref.watch(demoLedgerProvider);
    return Wrap(
      spacing: MetroSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(l.studentDemoLabel, style: context.text.labelSmall),
        for (final (code, label) in [
          ('VERIFIED', l.studentDemoPass),
          ('PENDING', l.studentDemoReview),
          ('REJECTED', l.studentDemoFail),
        ])
          ChoiceChip(
            label: Text(label),
            showCheckmark: false,
            selected: ledger.studentDemoOutcome == code,
            onSelected: (_) => setState(() => ledger.studentDemoOutcome = code),
          ),
      ],
    );
  }
}
